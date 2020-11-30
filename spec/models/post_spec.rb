require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }
  let!(:post_one_week_ago) { create(:post, :one_week_ago) }
  let!(:post_one_month_ago) { create(:post, :one_month_ago) }
  let!(:post) { create(:post) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(post).to be_valid
    end

    it "説明が140文字以内であること" do
      post = build(:post, content: "あ" * 141)
      post.valid?
      expect(post.errors[:content]).to include("は140文字以内で入力してください")
    end

    it "タイトルがなければ無効な状態であること" do
      post = build(:post, title: nil)
      post.valid?
      expect(post.errors[:title]).to include("を入力してください")
    end

    it "ユーザーIDがなければ無効な状態であること" do
      post = build(:post, user_id: nil)
      post.valid?
      expect(post.errors[:user_id]).to include("を入力してください")
    end

    it "値段がなければ無効な状態であること" do
      post = build(:post, price: nil)
      post.valid?
      expect(post.errors[:price]).to include("を入力してください")
    end

    it "カテゴリーがなければ無効な状態であること" do
      post = build(:post, category: nil)
      post.valid?
      expect(post.errors[:category]).to include("を入力してください")
    end

    it "人気度が1以上でなければ無効な状態であること" do
      post = build(:post, popularity: 0)
      post.valid?
      expect(post.errors[:popularity]).to include("は1以上の値にしてください")
    end

    it "人気度が5以下でなければ無効な状態であること" do
      post = build(:post, popularity: 6)
      post.valid?
      expect(post.errors[:popularity]).to include("は5以下の値にしてください")
    end
  end

  context "並び順" do
    it "最も最近の投稿が最初の投稿になっていること" do
      expect(post).to eq Post.first
    end
  end
end
