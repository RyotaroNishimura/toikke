require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { FactoryBot.create(:user) }

  context "ユーザーが有効であるとき" do

    it '名前とメールアドレスとパスワードがあれば登録できる' do
      expect(user).to be_valid
    end

    it  'メールアドレスが空白の場合' do
      user.email = ""
      expect(user).not_to be_valid
    end

  end

  context "ユーザーのメールアドレスのフォーマットが正しくない時" do
    it "メールアドレスのvalidateが正しく機能しているか" do
      expect(FactoryBot.build(:user, email: 'user@example,com')).not_to be_valid

      expect(FactoryBot.build(:user, email: 'user.example,com')).not_to be_valid

      expect(FactoryBot.build(:user, email: 'user@+example.com')).not_to be_valid

      expect(FactoryBot.build(:user, email: 'user@example..com')).not_to be_valid
    end
  end

  it "メールアドレスを小文字にした後の値が大文字を混ぜて登録されたメールアドレスと同じかどうか" do
    user.email = "User1@Example.com"
    user.save!
    expect(user.reload.email).to eq "user1@example.com"
  end

  it '重複したメールアドレスなら無効な状態であること' do
    FactoryBot.create(:user, email: "user1@example.com")
    user = FactoryBot.build(:user, email: "user1@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end


  it "パスワードが空白になってないか" do
    user.password = user.password_confirmation = 'a' * 6
    expect(user).to be_valid

    user.password = user.password_confirmation = '' * 6
    expect(user).to_not be_valid
  end

  describe "パスワードの長さ" do
    context "パスワードが6桁の時" do
      it "有効である" do
        user = FactoryBot.build(:user,password: "a" * 6, password_confirmation: "a" * 6)
        expect(user).to be_valid
      end
    end

    context "パスワードが5桁の時" do
      it "無効である" do
        user = FactoryBot.build(:user, password: "a" * 5,  password_confirmation: "a" * 5)
        expect(user).to_not be_valid
      end
    end
  end

  describe "ほかのブラウザでロウグインしていたらfalseを返す" do
    it "ダイジェストがなかった時のauthenticated?のテスト" do
      expect(user.authenticated?(:remember, '')).to eq false
    end
  end
end
