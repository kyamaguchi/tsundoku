class TagsController < ApplicationController
  def index
    context = 'guessed_tags'
    query = params[:keyword].present? ? ActsAsTaggableOn::Tag.where('name LIKE ?', "%#{params[:keyword]}%") : ActsAsTaggableOn::Tag
    @tags = query.order(taggings_count: :desc).all
  end
end
