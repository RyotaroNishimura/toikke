class GuestSessionsController < ApplicationController
  def create
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲスト'
      user.sex = 1
    end
    log_in user
    flash[:info] = 'ゲストユーザーでログインしました'
    redirect_to root_path
  end
end
