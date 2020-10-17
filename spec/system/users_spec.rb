require 'rails_helpler'

RSpec.decribe "Users", type: :system do
  let!(:user) { create(:user) }

  describe "新規登録ページ" do
    before do
      visit signup_path
    end

    context "ページレイアウト" do
      it "「新規登録」の文字列が存在することを確認" do
        expect(page).to have_content '新規登録'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('新規登録')
      end
    end
    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うとユーザー登録成功のフラッシュが表示されること" do
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
        expect(page).to have_content "クックログへようこそ！"
      end

      it "無効なユーザーでユーザー登録を行うとユーザー登録失敗のフラッシュが表示されること" do
        fill_in "名前", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "pass"
        click_button "登録する"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end

  describe "自分のプロフィールページ" do
    context "ページレイアウト" do
      before do
        visit user_path(user)
      end

      it "「自分のプロフィール」の文字列が存在することを確認" do
        expect(page).to have_content ''
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('')
      end

      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.name
      end
    end
  end
end
