class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    @post = Post.find(params[:post_id])
    @user = @post.user
    if current_user
      @favorite = Favorite.create(user_id: current_user.id, post_id: @post.id)
    end
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end

    if @user != current_user
      @user.notifications.create(
        post_id: @post.id,
        variety: 1,
        from_user_id: current_user.id
      )
      @user.update_attribute(:notification, true)
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    if current_user
      @unfavorite = Favorite.find_by(user_id: current_user.id, post_id: @post.id).destroy
    end

    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def index
    @favorites = current_user.favorites
  end
end
