class BookCommentsController < ApplicationController
  
   def create
    book = Book.find(params[:book_id])
    comment = current_user.books.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    redirect_to book_path(book)
  end
  
  def destroy
    Book.find(params[:id]).destroy
    redirect_to book_path(params[:book_id])

  private

  def book_params
    params.require(:book).permit(:comment)
  end
  
end
