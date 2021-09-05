class FavoritesController < ApplicationController
  def create
    book = Book.find_by(id: params[:book_id])
    favorite = current_user.favorites.new(book_id: book.id)
    favorite.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    book = Book.find_by(id: params[:book_id])
    favorite = book.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end