require "rails_helper"

RSpec.describe "投稿編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }

  context "ログインしているユーザーの場合" do
    it "レスポンスが正常に表示されること" do
      get edit_post_path(new_post)
      login_for_request(user)
      expect(response).to redirect_to edit_post_url(new_post)
      patch post_path(new_post), params: {
        post: {
          title: "七つの習慣", category: "政治", price: 1500, popularity: 5, content: "初めて本を紹介した"
        }
      }
      redirect_to new_post
      follow_redirect!
      expect(response).to render_template('posts/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      get edit_post_path(new_post)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      patch post_path(new_post), params: {
        post: {
          title: "七つの習慣", category: "政治", price: 1500, popularity: 5, content: "初めて本を紹介した"
        }
      }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  context "別アカウントのユーザーの場合" do
    it "ホーム画面にリダイレクトすること" do
      login_for_request(other_user)
      get edit_post_path(new_post)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      patch post_path(new_post), params: {
        post: {
          title: "七つの習慣", category: "政治", price: 1500, popularity: 5, content: "初めて本を紹介した"
        }
      }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
