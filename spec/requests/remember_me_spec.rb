require 'rails_helper'

RSpec.describe "Remember me", type: :request do
  let(:user) { FactoryBot.create(:user) }

  context "情報の制限" do
    it "ログイン中のみログアウトすること" do
      sign_in_as(user)
      expect(response).to redirect_to user_path(user)

      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil

      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil
    end
  end

  context "login with remembering" do
    it "remembers cookies" do
      post login_path, params: { session: { email: user.email, password: user.password, remember_me: '1'} }
      expect(response.cookies['remember_token']).to_not eq nil
    end
  end

  context "login without remembering" do
    it "doesn't remember cookies" do
      post login_path, params: { session: { email: user.email, password: user.password, remember_me: '1'} }
      delete logout_path


      post login_path, params: { session: { email: user.email, password: user.password, remember_me: '0'} }
      expect(response.cookies['remember_token']).to eq nil
    end
  end
end
