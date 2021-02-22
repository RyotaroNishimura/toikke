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
          title: "浜田山", address: "東京都杉並区浜田山3丁目", freeornot: 1, unnko: 3,syoben: 5, popularity: 5, content: "トイレットペーパーが切れていた"
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
          title: "浜田山", address: "東京都杉並区浜田山3丁目", freeornot: 1, unnko: 3,syoben: 5, popularity: 5, content: "トイレットペーパーが切れていた"
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
          title: "浜田山", address: "東京都杉並区浜田山3丁目", freeornot: 1, unnko: 3,syoben: 5, popularity: 5, content: "トイレットペーパーが切れていた"
        }
      }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
