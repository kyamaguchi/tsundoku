class TagsController < ApplicationController
  def index
    @tag_names = find_ordered_tag_names
    @summary = summarize_guessed_tags

    @q = ActsAsTaggableOn::Tag.ransack(params[:q])
    @tags = if params[:exclude_tagged] == '1'
      tags = @q.result.includes(:taggings).order(taggings_count: :desc).all
      ids_without_tagged = @summary.map(&:last).select{|h| h["guessed_tags_size"] == h["size"] }.map{|h| h["id"] }
      @tags = tags.select{|tag| ids_without_tagged.include?(tag.id) }
    else
      @q.result.includes(:taggings).order(taggings_count: :desc).page(params[:page]).per(100)
    end
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

  def summary
    @tag_names = find_ordered_tag_names
    @summary = summarize_guessed_tags
  end

  private

  def find_ordered_tag_names
    ActsAsTaggableOn::Tagging.includes(:tag).where(context: :tags).all
      .group_by{|t| t.tag.name }.map{|name,r| [name, r.size] }
      .sort_by(&:last).reverse.map(&:first)
  end

  def summarize_guessed_tags
    result = {}
    ActsAsTaggableOn::Tagging.includes(:tag).group_by(&:taggable_id).each do |_,taggings|
      tag_names = taggings.select{|t| t.context == "tags" }.map{|t| t.tag.name }
      taggings.each do |t|
        next if t.context == "tags"
        result[t.tag.name] ||= {"guessed_tags_size" => 0, "size" => 0}
        result[t.tag.name]["id"] ||= t.tag.id
        result[t.tag.name]["guessed_tags_size"] += 1
        result[t.tag.name]["size"] += 1
        tag_names.each do |tag_name|
          result[t.tag.name][tag_name] ||= 0
          result[t.tag.name][tag_name] += 1
          result[t.tag.name]["size"] += 1
        end
      end
    end
    result.sort_by{|k,v| [-v["guessed_tags_size"], -v["size"]] }
  end
end
