class BooksController < ApplicationController
  def index
    @books = if params[:author_id].present?
      Book.joins(:author).where(authors: {id: params[:author_id]}).page(params[:page])
    else
      Book.page(params[:page])
    end
  end

  def mark_as_read
    Book.where(id: params[:book_ids]).all.each do |book|
      book.update(read: true)
    end
    redirect_back(fallback_location: books_path, notice: 'Marked as read')
  end
end
