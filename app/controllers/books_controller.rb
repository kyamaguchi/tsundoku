class BooksController < ApplicationController
  def index
    @authors = Author.includes(:books).order(:name).all
    @q = Book.ransack(params[:q])
    books_query = @q.result
    if params[:tag_name].present?
      if params[:context].present?
        books_query = books_query.tagged_with(params[:tag_name], on: params[:context])
      else
        books_query = books_query.tagged_with(params[:tag_name])
      end
    end
    @books = books_query.page(params[:page])
  end

  def mark_as_read
    Book.where(id: params[:book_ids]).all.each do |book|
      book.update(read: true)
    end
    redirect_back(fallback_location: books_path, notice: 'Marked as read')
  end
end
