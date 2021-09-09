class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book.id
    unless @book_comment.save
      render "error"
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    comment = BookComment.find(params[:id])
    if comment.user == current_user
      comment.destroy
    else
      redirect_to book_path(params[:book_id])
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:body)
  end
end
