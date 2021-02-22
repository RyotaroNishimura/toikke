require 'rails_helper'

RSpec.describe "投稿", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, user_id: user.id, post: post) }

  describe "トイレ情報の登録ページ" do
    before do
      login_for_system(user)
      visit new_post_path
    end

    context "ページレイアウト" do
      it "「トイレ情報の作成」の文字列が存在すること" do
        expect(page).to have_content 'トイレ情報の作成'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('トイレ情報の作成')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'どこのトイレ（地域と建物など）'
        expect(page).to have_content 'トイレの住所'
        expect(page).to have_content 'お金がかかるのか（コンビニは有料にチェック）'
        expect(page).to have_content '大便器の数'
        expect(page).to have_content '小便器の数（男性のみ）'
        expect(page).to have_content 'きれい度'
        expect(page).to have_content 'メモ'
      end
    end

    context "本の登録処理" do
      it "有効な情報で本の登録を行うと本の登録成功のフラッシュが表示されること" do
        fill_in "post[title]", with: "浜田山"
        fill_in "post[adress]", with: "東京都杉並区浜田山3丁目"
        fill_in "post[freeornot]", with: 1500
        fill_in "post[popularity]", with: 5
        fill_in "post[unnko]", with: 3
        fill_in "post[syoben]", with: 5
        fill_in "post[content]", with: "トイレットペーパーが切れてた"
        click_button "登録する"
        expect(page).to have_content "投稿が作られました!"
      end

      it "無効な情報で料理登録を行うと料理登録失敗のフラッシュが表示されること" do
        fill_in "post[title]", with: "浜田山"
        fill_in "post[adress]", with: "東京都杉並区浜田山3丁目"
        fill_in "post[freeornot]", with: 1500
        fill_in "post[popularity]", with: 5
        fill_in "post[unnko]", with: 3
        fill_in "post[syoben]", with: 5
        fill_in "post[content]", with: "トイレットペーパーが切れてた"
        click_button "登録する"
        expect(page).to have_content "Titleを入力してください"
      end
    end
  end

  describe "トイレの詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit post_path(post)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{post.title}")
      end

      it "トイレの情報が表示されること" do
        expect(page).to have_content post.title
        expect(page).to have_content post.adress
        expect(page).to have_content post.freeornot
        expect(page).to have_content post.unnko
        expect(page).to have_content post.syoben
        expect(page).to have_content post.popularity
        expect(page).to have_content post.content
      end
    end

    context "投稿の削除", js: true do
      it "削除成功のフラッシュが表示されること" do
        login_for_system(user)
        visit post_path(post)
        within find('.change-post') do
          click_on '削除'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '投稿が削除されました'
      end
    end
  end

  describe "投稿編集ページ" do
    before do
      login_for_system(user)
      visit post_path(post)
      click_link "編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('トイレの情報の編集')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'どこのトイレ（地域と建物など）'
        expect(page).to have_content 'トイレの住所'
        expect(page).to have_content 'お金がかかるのか（コンビニは有料にチェック）'
        expect(page).to have_content '大便器の数'
        expect(page).to have_content '小便器の数（男性のみ）'
        expect(page).to have_content 'きれい度'
        expect(page).to have_content 'メモ'
      end
    end

    context "トイレ情報の更新処理" do
      it "有効な更新" do
        fill_in "post[title]", with: "浜田山"
        fill_in "post[adress]", with: "東京都杉並区浜田山3丁目"
        fill_in "post[freeornot]", with: 1
        fill_in "post[unnko]", with: 3
        fill_in "post[syoben]", with: 5
        fill_in "post[popularity]", with: 5
        fill_in "post[content]", with "トイレットペーパが補充されてた"
        click_button "更新する"
        expect(page).to have_content "本の情報が更新されました!"
        expect(post.reload.title).to eq "浜田山"
        expect(post.reload.adress).to eq "東京都杉並区浜田山3丁目"
        expect(post.reload.freeornot).to eq 1
        expect(post.reload.unnko).to eq 3
        expect(post.reload.syoben).to eq 5
        expect(post.reload.popularity).to eq 5
        expect(post.reload.content).to eq "トイレットペーパーが補充されてた"
      end

      it "無効な更新" do
        fill_in "post[title]", with: ""
        click_button "更新する"
        expect(page).to have_content 'Titleを入力してください'
        expect(post.reload.title).not_to eq ""
      end
    end

    context "投稿の削除処理", js: true do
      it "削除成功のフラッシュが表示されること" do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '投稿が削除されました'
      end
    end

    context "コメントの登録＆削除" do
      it "自分の料理に対するコメントの登録＆削除が正常に完了すること" do
        login_for_system(user)
        visit post_path(post)
        fill_in "comment_content", with: "めっちゃ面白いじゃん"
        click_button "コメント"
        within find("#comment-#{Comment.last.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: 'めっちゃ面白いじゃん'
        end
        expect(page).to have_content "コメントを追加しました!"
        click_link "削除", href: comment_path(Comment.last)
        expect(page).to have_content "コメントを削除しました"
      end

      it "別ユーザーの料理のコメントには削除リンクが無いこと" do
        login_for_system(other_user)
        visit post_path(post)
        within find("#comment-#{comment.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: comment.content
          expect(page).not_to have_link '削除', href: post_path(post)
        end
      end
    end
  end

  context "検索機能" do
    context "ログインしている場合" do
      before do
        login_for_system(user)
        visit root_path
      end

      it "ログイン後の各ページに検索窓が表示されていること" do
        expect(page).to have_css 'form#post_search'
        visit users_path
        expect(page).to have_css 'form#post_search'
        visit user_path(user)
        expect(page).to have_css 'form#post_search'
        visit edit_user_path(user)
        expect(page).to have_css 'form#post_search'
        visit following_user_path(user)
        expect(page).to have_css 'form#post_search'
        visit followers_user_path(user)
        expect(page).to have_css 'form#post_search'
        visit posts_path
        expect(page).to have_css 'form#post_search'
        visit post_path(post)
        expect(page).to have_css 'form#post_search'
        visit new_post_path
        expect(page).to have_css 'form#post_search'
        visit edit_post_path(post)
        expect(page).to have_css 'form#post_search'
      end

      it "フィードの中から検索ワードに該当する結果が表示されること" do
        create(:post, title: '福岡天神地下南側', user: user)
        create(:post, title: '福岡天神地下北側', user: other_user)
        create(:post, title: '博多駅筑紫口', user: user)
        create(:post, title: '博多駅博多口', user: other_user)

        fill_in 'q_name_cont', with: '天神'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”天神”の検索結果：1件"
        within find('.posts') do
          expect(page).to have_css 'li', count: 1
        end
        fill_in 'q_name_cont', with: '博多'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”博多”の検索結果：1件"
        within find('.posts') do
          expect(page).to have_css 'li', count: 1
        end

        user.follow(other_user)
        fill_in 'q_name_cont', with: '天神'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”天神”の検索結果：2件"
        within find('.posts') do
          expect(page).to have_css 'li', count: 2
        end
        fill_in 'q_name_cont', with: '博多'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”博多”の検索結果：2件"
        within find('.posts') do
          expect(page).to have_css 'li', count: 2
        end
      end

      it "検索ワードを入れずに検索ボタンを押した場合、投稿一覧が表示されること" do
        fill_in 'q_name_cont', with: ''
        click_button '検索'
        expect(page).to have_css 'h3', text: "投稿一覧"
        within find('.posts') do
          expect(page).to have_css 'li', count: Post.count
        end
      end
    end

    context "ログインしていない場合" do
      it "検索窓が表示されないこと" do
        visit root_path
        expect(page).not_to have_css 'form#post_search'
      end
    end
  end
end
