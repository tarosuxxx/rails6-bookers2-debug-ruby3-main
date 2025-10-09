class SearchesController < ApplicationController
  def search
    @range = params[:range] # 検索対象 (User または Book)
    @word = params[:word]   # 検索キーワード
    @method = params[:search_method] # 検索手法 (完全、前方、後方、部分)

    if @range == "User"
      @users = User.looks(@method, @word)
    else
      @books = Book.looks(@method, @word)
    end
  end
end
