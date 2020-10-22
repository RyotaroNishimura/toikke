require "rails_helper"

RSpec.describe "ログイン", type: :request do
  let!(:user) { create(:user) }

  it "正常なレスポンスを返すこと" do
    get login_path
    expect(response).to be_success
    expect(response).to have_http_status "200"
  end

  it "有効なユーザーでログイン＆ログアウト" do
    get login_path
    post login_path, params: { session: { email: user.email,
                                          password: user.password } }
    redirect_to user
    follow_redirect!
    expect(response).to render_template('users/show')
    expect(is_logged_in?).to be_truthy
    delete logout_path
    expect(is_logged_in?).not_to be_truthy
    redirect_to root_url
  end

  it "無効なユーザーでログイン" do
    get login_path
    post login_path, params: { session: { email: "xxx@example.com",
                                         password: user.password } }
    expect(is_logged_in?).not_to be_truthy
  end
  it "有効なユーザーで登録" do
    expect {
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    }.to change(User, :count).by(1)
    redirect_to @user
    follow_redirect!
    expect(response).to render_template('users/show')
    expect(is_logged_in?).to be_truthy # 追記
  end

  it "無効なユーザーで登録" do
    expect {
      post users_path, params: { user: { name: "",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "pass" } }
    }.not_to change(User, :count)
    expect(is_logged_in?).not_to be_truthy # 追記
  end
end
