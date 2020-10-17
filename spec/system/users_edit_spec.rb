//require 'rails_helper'

RSpec.describe "Edit", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "successful edit" do
    visit user_path(user)
    valid_login(user)
    click_link "プロフィール編集"

    fill_in "メールアドレス", with: "edit@example.com"
    click_button "変更を更新"

    expect(current_path).to eq user_path(user)
    expect(user.reload.email).to eq "edit@example.com"
  end

  scenario "unsuccessful edit" do
    valid_login(user)
    visit user_path(user)
    click_link "プロフィール編集"

    fill_in "メールアドレス", with: "example@invalid"
    fill_in "パスワード", with:"password", match: :first
    fill_in "パスワード(確認)", with: "pasaword"
    click_button "変更を更新"

    expect(user.reload.email).to_not eq "example@invalid"
  end
end
