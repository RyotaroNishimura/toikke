require 'rails_helper'

RSpec.feature "Login", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  scenario "ユーザーがログインに成功し、その後ログアウトすること" do
    valid_login(user)

    expect(current_path).to eq user_path(user)
    expect(page).to_not have_content "ログイン"

    click_link "ログアウト"

    expect(current_path).to eq root_path
    expect(page).to have_content "ログイン"
  end

  scenario "無効なデータではユーザーがログインに失敗する" do
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: ""
    fill_in "Password", with: ""
    click_button "ログイン"

    expect(current_path).to eq login_path
    expect(page).to have_content "ログイン"
    expect(page).to have_content "ログインに失敗しました"
  end
end
