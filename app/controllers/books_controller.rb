class BooksController < ApplicationController
  def index
    process_tag_sample_param

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

  private

    def process_tag_sample_param
      if params[:tag_sample] == 'include'
        params[:q][:tag_eq] = 'サンプル'
      elsif params[:tag_sample] == 'exclude'
        params[:q][:tag_not_eq] = 'サンプル'
      end
    end
end
