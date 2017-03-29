class AuthorsController < ApplicationController
  def index
    @authors = Author.includes(:books).order(:name).all.select{|a| params[:books_count].present? ? (a.books.size >= params[:books_count].to_i) : true }
  end
end
