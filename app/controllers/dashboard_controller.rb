class DashboardController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tagging.where(context: :tags).includes(:tag).all.group_by(&:tag_id).map{|tag_id, group| [group.first.tag.taggings_count, group.first.tag.name] }.sort_by(&:first).reverse
  end
end
