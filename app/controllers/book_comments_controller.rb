class BookCommentsController < ApplicationController
  before_action :authenticate_user! 

    def create
    @book = Book.find(params[:book_id])
    @book_comment = BookComment.new(book_comment_params)
    @book_comment.user_id = current_user.id
    @book_comment.book_id = @book.id
    
    # 【修正後のコード】
    if @book_comment.save
      # 保存成功時: JS または HTML に応答
      respond_to do |format|
        format.js   # Ajaxリクエストであれば create.js.erb を実行
        format.html { redirect_to @book } # HTMLリクエストであれば書籍詳細ページにリダイレクト
      end
    else
      # 保存失敗時: 
      # JS: create.js.erb を実行し、JS側でエラーを表示（今回は簡略化のため成功時と同じ応答）
      # HTML: エラーメッセージを表示して render で show テンプレートを再描画
      # 今回はAjaxの課題なので、成功時と同じく JS に応答させます。（コメントは投稿されません）
      respond_to do |format|
        format.js
        format.html { redirect_to @book } # エラー時もとりあえずリダイレクトで対応
      end
    end
  end

 def destroy
    @book = Book.find(params[:book_id])
    book_comment = @book.book_comments.find(params[:id])
    book_comment.destroy
    
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
