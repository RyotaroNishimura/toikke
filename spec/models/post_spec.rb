require 'rails_helper'


RSpec.describe Post, type: :model do

  let(:post) { FactoryBot.create(:post) }

  it '投稿が可能である' do
    expect(post).to be_valid
  end

  it 'user_idがなければ投稿できない' do
    post.user_id = nil
    post.valid?
    expect(post.errors).to be_added(:user_id, :blank)
  end
end
