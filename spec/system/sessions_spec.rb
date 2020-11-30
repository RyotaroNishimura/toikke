require 'rails_helper'

RSpec.describe "ログイン", type: :system do
  describe "ログインページ" do
    let!(:user) { create(:user) }

    before do
      visit login_path
    end

    it "「ログイン」の文字列が存在することを確認" do
      expect(page).to have_content 'ログイン'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('ログイン')
    end

    it "ヘッダーにログインページへのリンクがあることを確認" do
      expect(page).to have_link 'ログイン', href: login_path
    end

    it "ログインフォームのラベルが正しく表示される" do
      expect(page).to have_content 'メールアドレス'
      expect(page).to have_content 'パスワード'
    end

    it "ログインフォームが正しく表示される" do
      expect(page).to have_css 'input#user_email'
      expect(page).to have_css 'input#user_password'
    end

    it "「このデータを保存しますか？」チェックボックスが表示される" do
      expect(page).to have_content 'このデータを保存しますか？'
      expect(page).to have_css 'input#session_remember_me'
    end

    it "ログインボタンが表示される" do
      expect(page).to have_button 'ログイン'
    end

    it "無効なユーザーでログインを行うとログインが失敗することを確認" do
      fill_in "user_email", with: "userexample.com"
      fill_in "user_password", with: "pass"
      click_button "ログイン"
      expect(page).to have_content 'ログインに失敗しました'

      visit root_path
      expect(page).not_to have_content "ログインに失敗しました"
    end

    it "有効なユーザーでログインする前後でヘッダーが正しく表示されていることを確認" do
      expect(page).to have_link '新規登録', href: signup_path
      expect(page).to have_link 'ログイン', href: login_path
      expect(page).not_to have_link 'ゲストログイン', href: "＃"

      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "ログイン"

      expect(page).to have_link 'ホーム', href: root_path
      expect(page).to have_link 'お気に入り', href: favorites_path
      expect(page).to have_link 'ユーザーの一覧', href: users_path
      expect(page).to have_link '自分のページ', href: user_path(user)
      expect(page).not_to have_link 'プロフィール編集', href: edit_user_path(user, match: :first)
      expect(page).to have_link 'ログアウト', href: logout_path
    end
  end
end
