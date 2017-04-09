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

  def update_selected
    books = Book.where(id: params[:book_ids]).all
    if update_tag?
      books.each do |book|
        if params[:type] == 'add_tag'
          book.tag_list.add(params[:tag].strip)
        elsif params[:type] == 'remove_tag'
          book.tag_list.remove(params[:tag].strip)
        end
        book.save!
      end
    elsif update_attrs.present?
      books.each do |book|
        book.update(update_attrs)
      end
    end
    redirect_back(fallback_location: books_path, notice: 'Updated')
  end

  private

    def load_tag_list
      @tag_list = ActsAsTaggableOn::Tagging.includes(:tag).where(context: :tags).map{|t| t.tag }.uniq.sort
    end

    def update_attrs
      case params[:type]
      when "read_true"
        {read: true}
      when "read_false"
        {read: false}
      else
        {}
      end
    end

    def update_tag?
      %w[add_tag remove_tag].include?(params[:type]) && params[:tag].present?
    end
end
