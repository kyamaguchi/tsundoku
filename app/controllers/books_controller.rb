class BooksController < ApplicationController
  def index
    @authors = Author.includes(:books).order(:name).all
    @tags = Book.pluck(:tag).uniq.reject(&:blank?).sort + ['None']
  end

  def data
    render json: Book.limit(params[:limit]).offset(params[:offset]).to_json
  end

  def mark_as_read
    Book.where(id: params[:book_ids]).all.each do |book|
      book.update(read: true)
    end
    redirect_back(fallback_location: books_path, notice: 'Marked as read')
  end
end
