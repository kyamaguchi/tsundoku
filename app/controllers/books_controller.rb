class BooksController < ApplicationController
  before_action :load_tag_list

  def index
    @authors = Author.order(:name).all
    @total_books_count = Book.count
  end

  def data
    render json: Book.includes(:guessed_tags, :tags).order(date: :desc).limit(params[:limit]).offset(params[:offset]).to_json(tag_ids: @tag_list.map(&:id))
  end

  def update_selected
    books = Book.where(id: params[:book_ids]).all
    books.each do |book|
      if params[:type] == 'add_tag'
        book.tag_list.add(tag_to_update)
      elsif params[:type] == 'remove_tag'
        book.tag_list.remove(tag_to_update)
      end
      book.save!
    end
    redirect_back(fallback_location: books_path, notice: 'Updated')
  end

  private

    def load_tag_list
      @tag_list = ActsAsTaggableOn::Tagging.includes(:tag).where(context: :tags).map{|t| t.tag }.uniq.sort
    end

    def tag_to_update
      params[:tag_text].strip.presence || params[:tag_select].strip
    end
end
