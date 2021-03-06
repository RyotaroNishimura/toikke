class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]

  def index

  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new

  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:info] = "投稿が作られました!"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'posts/new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:info] = "トイレの情報が更新されました!"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if current_user.admin? || current_user?(@post.user)
      @post.delete
      flash[:info] = "投稿が削除されました!"
      redirect_to request.referrer == user_url(@post.user) ? user_url(@post.user) : root_url
    else
      flash[:danger] = "他の人の投稿は削除できません"
      redirect_to root_url
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :adress, :freeornot, :unnko, :syoben, :popularity, :content, :image)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
