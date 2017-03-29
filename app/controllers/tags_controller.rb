class TagsController < ApplicationController
  def index
    @q = ActsAsTaggableOn::Tag.ransack(params[:q])
    @tags = @q.result.order(taggings_count: :desc).page(params[:page]).per(100)
  end
end
