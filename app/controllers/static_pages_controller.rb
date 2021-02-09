class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = User.all
      @post = Post.all
      @feed_items = @post.paginate(page: params[:page], per_page: 5)
    end
  end

end
