class TagsController < ApplicationController
  def index
    @q = ActsAsTaggableOn::Tag.ransack(params[:q])
    @tags = @q.result.order(taggings_count: :desc).page(params[:page]).per(100)
  end

  def apply_to_books
    if params[:new_tag].present?
      ActsAsTaggableOn::Tag.where(id: params[:tag_ids]).includes(:taggings).all.each do |tag|
        tag.taggings.map(&:taggable).each do |book|
          book.tag_list.add(params[:new_tag].strip)
          book.save!
        end
      end
    end
    redirect_back(fallback_location: tags_path, notice: 'Applied tags to books')
  end
end
