require 'rails_helper'

RSpec.feature "SignUps", type: :feature do
  include ActiveJob::TestHelper

  scenario "ユーザーはサインアップに成功する" do
    visit root_path
    click_link "登録"


    perform_enqueued_jobs do

      expect {
        fill_in "名前", with: "Example User"
        fill_in "Eメール", with: "user1@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with:"password"
        click_button "登録"
      }.to change(User, :count).by(1)

    end
  end
end
