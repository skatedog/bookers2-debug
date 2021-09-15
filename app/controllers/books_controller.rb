class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    impressionist(@book, nil, :unique => [:user_id])
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    @books = sorted_books
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = sorted_books
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

  def sorted_books
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day

    Book.includes(:favorites).sort do |a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
