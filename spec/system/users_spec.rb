require 'rails_helper'

RSpec.describe "ユーザー", type: :system do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  describe "ユーザー一覧ページ" do
    context "管理者ユーザーの場合" do
      it "ぺージネーション、自分以外のユーザーの削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(admin_user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).to have_content "#{u.name} | 削除" unless u == admin_user
        end
      end
    end

    context "管理者ユーザー以外の場合" do
      it "ぺージネーション、自分のアカウントのみ削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if u == user
            expect(page).to have_content "#{u.name} | 削除"
          else
            expect(page).not_to have_content "#{u.name} | 削除"
          end
        end
      end
    end
  end

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
        fill_in "性別", with: 1
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録"
        expect(page).to have_content "トイッケへようこそ"
      end

      it "無効なユーザーでユーザー登録を行うとユーザー登録失敗のフラッシュが表示されること" do
        fill_in "名前", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "pass"
        click_button "登録"
        expect(page).to have_content "Nameを入力してください"
        expect(page).to have_content "Password confirmationとPasswordの入力が一致しません"
      end
    end
  end

  describe "自分のページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        create_list(:post, 10, user: user)
        visit user_path(user)
      end

      it "「自分のプロフィール」の文字列が存在することを確認" do
        expect(page).to have_content 'プロフィール'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール')
      end

      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.name
      end

      it "プロフィール編集ページへのリンクが表示されていることを確認" do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end

      it "投稿の件数が表示されていることを確認" do
        expect(page).to have_content "投稿 (#{user.posts.count})"
      end

      it "投稿の情報が表示されていることを確認" do
        Post.take(6).each do |post|
          expect(page).to have_link post.name
          expect(page).to have_content post.title
          expect(page).to have_content post.adress
          expect(page).to have_content post.user.name
          expect(page).to have_content post.unnko
          expect(page).to have_content post.syoben
          expect(page).to have_content post.content
          expect(page).to have_content post.freeornot
        end
      end

      it "投稿のページネーションが表示されていることを確認" do
        expect(page).to have_css "div.pagination"
      end
    end

    context "ユーザーのフォロー/アンフォロー処理", js: true do
      it "ユーザーのフォロー/アンフォローができること" do
        login_for_system(user)
        visit user_path(other_user)
        expect(page).to have_button 'フォロー'
        click_button 'フォロー'
        expect(page).to have_button 'フォロー中'
        click_button 'フォロー中'
        expect(page).to have_button 'フォロー'
      end
    end

    context "お気に入り登録/解除" do
      before do
        login_for_system(user)
      end

      it "投稿のお気に入り登録/解除ができること" do
        expect(user.favorite?(post)).to be_falsey
        user.favorite(post)
        expect(user.favorite?(post)).to be_truthy
        user.unfavorite(post)
        expect(user.favorite?(post)).to be_falsey
      end

      it "トップページからお気に入り登録/解除ができること", js: true do
        visit root_path
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{post.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{post.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{post.id}/create"
      end

      it "ユーザー個別ページからお気に入り登録/解除ができること", js: true do
        visit user_path(user)
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{post.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{post.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{post.id}/create"
      end

      it "個別ページからお気に入り登録/解除ができること", js: true do
        visit post_path(post)
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{post.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{post.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{post.id}/create"
      end

      it "お気に入り一覧ページが期待通り表示されること" do
        visit favorites_path
        expect(page).not_to have_css ".favorite-post"
        user.favorite(post)
        user.favorite(other_post)
        visit favorites_path
        expect(page).to have_css ".favorite-post", count: 2
        expect(page).to have_content post.name
        expect(page).to have_content post.content
        expect(page).to have_content "投稿者 #{user.name}"
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content other_post.name
        expect(page).to have_content other_post.content
        expect(page).to have_content "投稿者 #{other_user.name}"
        expect(page).to have_link other_user.name, href: user_path(other_user)
        user.unfavorite(other_post)
        visit favorites_path
        expect(page).to have_css ".favorite-post", count: 1
        expect(page).to have_content post.name
      end
    end

    context "通知生成" do
      before do
        login_for_system(user)
      end

      context "自分以外のユーザーの投稿に対して" do
        before do
          visit post_path(other_post)
        end

        it "お気に入り登録によって通知が作成されること" do
          find('.like').click
          visit post_path(other_post)
          expect(page).to have_css 'li.no_notification'
          logout
          login_for_system(other_user)
          expect(page).to have_css 'li.new_notification'
          visit notifications_path
          expect(page).to have_css 'li.no_notification'
          expect(page).to have_content "あなたの投稿が#{user.name}さんにお気に入り登録されました。"
          expect(page).to have_content other_post.name
          expect(page).to have_content other_post.content
          expect(page).to have_content other_post.created_at.strftime("%Y/%m/%d(%a) %H:%M")
        end

        it "コメントによって通知が作成されること" do
          fill_in "comment_content", with: "コメントしました"
          click_button "コメント"
          expect(page).to have_css 'li.no_notification'
          logout
          login_for_system(other_user)
          expect(page).to have_css 'li.new_notification'
          visit notifications_path
          expect(page).to have_css 'li.no_notification'
          expect(page).to have_content "あなたの投稿に#{user.name}さんがコメントしました。"
          expect(page).to have_content '「コメントしました」'
          expect(page).to have_content other_post.name
          expect(page).to have_content other_post.content
          expect(page).to have_content other_post.created_at.strftime("%Y/%m/%d(%a) %H:%M")
        end
      end

      context "自分の投稿に対して" do
        before do
          visit post_path(post)
        end

        it "お気に入り登録によって通知が作成されないこと" do
          find('.like').click
          visit post_path(post)
          expect(page).to have_css 'li.no_notification'
          visit notifications_path
          expect(page).not_to have_content 'お気に入りに登録されました。'
          expect(page).not_to have_content post.title
          expect(page).not_to have_content post.content
          expect(page).not_to have_content post.created_at
        end

        it "コメントによって通知が作成されないこと" do
          fill_in "comment_content", with: "自分でコメント"
          click_button "コメント"
          expect(page).to have_css 'li.no_notification'
          visit notifications_path
          expect(page).not_to have_content 'コメントしました。'
          expect(page).not_to have_content '自分でコメント'
          expect(page).not_to have_content other_post.title
          expect(page).not_to have_content other_post.content
          expect(page).not_to have_content other_post.created_at
        end
      end
    end
  end

  describe "プロフィール編集ページ" do
    before do
      login_for_system(user)
      visit user_path(user)
      click_link "プロフィール編集", match: :first
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール編集')
      end
    end

    it "有効なプロフィール更新を行うと、更新成功のフラッシュが表示されること" do
      fill_in "名前", with: "Edit Example User"
      fill_in "メールアドレス", with: "edit-user@example.com"
      fill_in "パスワード", with: "Edit Example User"
      fill_in "パスワード(確認)", with: "Edit Example User"
      fill_in "性別", with "1"
      click_button "変更を更新"
      expect(page).to have_content "プロフィールのアップデートに成功しました"
      expect(user.reload.name).to eq "Edit Example User"
      expect(user.reload.email).to eq "edit-user@example.com"
      expect(user.reload.password).to eq "password"
      expect(user.reload.password_confirmation).to eq "password"
    end

    it "無効なプロフィール更新をしようとすると、適切なエラーメッセージが表示されること" do
      fill_in "名前", with: ""
      fill_in "メールアドレス", with: ""
      click_button "変更を更新"
      expect(page).to have_content 'Nameを入力してください'
      expect(page).to have_content 'Emailを入力してください'
      expect(page).to have_content 'Emailは不正な値です'
      expect(user.reload.email).not_to eq ""
    end

    context "アカウント削除処理", js: true do
      it "正しく削除できること" do
        click_link "アカウントを削除する"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "自分のアカウントを削除しました"
      end
    end
  end
end
