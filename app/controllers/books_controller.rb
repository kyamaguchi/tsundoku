class BooksController < ApplicationController
  def index
    @authors = Author.order(:name).all
    @books = if params[:author_id].present?
      Book.joins(:author).where(authors: {id: params[:author_id]}).page(params[:page])
    else
      Book.page(params[:page])
    end
  end

  def search
    index
    render :index
  end
end
