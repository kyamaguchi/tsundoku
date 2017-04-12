class DashboardController < ApplicationController
  def index
    @tag_list = ActsAsTaggableOn::Tagging.includes(:tag).where(context: :tags).map{|t| t.tag }.uniq.sort_by{|tag| tag.taggings_count }.reverse
    # @tags = ActsAsTaggableOn::Tagging.where(context: :tags).includes(:tag).all.group_by(&:tag_id).map{|tag_id, group| [group.first.tag.taggings_count, group.first.tag.name, tag_id] }.sort_by(&:first).reverse
  end
end
