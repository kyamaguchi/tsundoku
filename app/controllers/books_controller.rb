class BooksController < ApplicationController
  def index
    @authors = Author.includes(:books).order(:name).all
    @q = Book.ransack(params[:q])
    @books = @q.result.page(params[:page])
  end

  def mark_as_read
    Book.where(id: params[:book_ids]).all.each do |book|
      book.update(read: true)
    end
    redirect_back(fallback_location: books_path, notice: 'Marked as read')
  end
end
