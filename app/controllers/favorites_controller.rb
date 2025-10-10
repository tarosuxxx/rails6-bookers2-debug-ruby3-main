class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save

    respond_to do |format|
      format.js # app/views/favorites/create.js.erb を呼び出す
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy

    respond_to do |format|
      format.js # app/views/favorites/destroy.js.erb を呼び出す
    end
  end
end
