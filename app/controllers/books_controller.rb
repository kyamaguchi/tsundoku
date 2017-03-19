class BooksController < ApplicationController
  def index
    @authors = Book.pluck(:author).uniq.sort
    @books = if params[:author].present?
      Book.where(author: params[:author]).page(params[:page])
    else
      Book.page(params[:page])
    end
  end

  def search
    index
    render :index
  end
end
