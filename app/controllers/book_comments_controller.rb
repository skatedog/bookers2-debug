class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @new_book = Book.new
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book.id
    if @book_comment.save
      redirect_to book_path(@book.id)
    else
      render "books/show"
    end
  end

  def destroy
    comment = BookComment.find(params[:id])
    if comment.user == current_user
      comment.destroy
      redirect_to book_path(params[:book_id])
    else
      redirect_to book_path(params[:book_id])
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:body)
  end
end
