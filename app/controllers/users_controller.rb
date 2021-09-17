class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @book = Book.new
    @user = User.find(params[:id])

    if params[:serch_date]
      @books = @user.books.where(created_at: params[:serch_date].to_date.all_day)
      @serch_books_count = @books.count
    else
      if params[:category]
        @books = @user.books.where(category: params[:category])
      else
        @books = @user.books
      end
      @serch_books_count = nil
    end
    @days = [*1..6].reverse.map { |n| n.to_s + "日前" } << "今日"
    @datas = [*0..6].reverse.map { |n| @user.books.posted_n_day_ago(n).count }
  end

  def index
    @user = current_user
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.followeds
  end

  def follower
    user = User.find(params[:id])
    @users = user.followers
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
