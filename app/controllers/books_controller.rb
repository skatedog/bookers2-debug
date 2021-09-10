class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    @books = Book.find(book_ids)
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.find(book_ids)
      render 'index'
    end
  end

  def edit
    if @book.user != current_user
      redirect_to books_path
    end
  end


  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def book_ids
    Favorite.where("created_at > ?", 1.week.ago).group(:book_id).order("count(*) desc").pluck(:book_id)
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
