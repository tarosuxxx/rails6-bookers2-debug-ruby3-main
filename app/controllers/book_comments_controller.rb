class BookCommentsController < ApplicationController
  before_action :authenticate_user! 

  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save

    redirect_to request.referer
  end

  def destroy
     book_comment = BookComment.find(params[:id])
    if book_comment.user_id == current_user.id
      book_comment.destroy
    end
    
    redirect_to request.referer
  end

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
