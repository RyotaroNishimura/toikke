require 'rails_helper'

RSpec.describe "スタティックページ", type: :system do

  describe "ホームページ" do

    before do
      visit root_path
    end

    it "ホームページがroot_pathであること" do
      expect root_path
    end

    it "タイトルが正しく表示されていること" do
      expect(page).to have_title ('RecomendApp')
    end
  end

end
