class BooksController < ApplicationController
  before_action :load_tag_list

  def index
    @authors = Author.includes(:books).order(:name).all
    @tags = Book.pluck(:tag).uniq.reject(&:blank?).sort + ['None']
    @total_books_count = Book.count
  end

  def data
    render json: Book.includes(:tags => :taggings).limit(params[:limit]).offset(params[:offset]).to_json(tag_ids: @tag_list.map(&:id))
  end

  def mark_as_read
    Book.where(id: params[:book_ids]).all.each do |book|
      book.update(read: true)
    end
    redirect_back(fallback_location: books_path, notice: 'Marked as read')
  end

  private

    def load_tag_list
      @tag_list = ActsAsTaggableOn::Tagging.includes(:tag).where(context: :tags).map{|t| t.tag }.uniq.sort
    end
end
