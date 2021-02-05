class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = User.all.build
      @post = Post.all.build
      @feed_items = @current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end
end
