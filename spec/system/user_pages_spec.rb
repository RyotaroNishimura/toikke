require 'rails_helper'

RSpec.describe "UserPages", type: :system do
  describe "signup page" do
    before do
      visit signup_path
    end

    it "新規登録ページにSign upと表示されていること" do
      expect(page).to have_content "新規登録"
    end

    it "タイトルが正しく表示されていること" do
      expect(page).to have_title full_title('Sign up')
    end
  end
end
