class TagsController < ApplicationController
  def index
    @q = ActsAsTaggableOn::Tag.ransack(params[:q])
    @tags = @q.result.includes(:taggings).order(taggings_count: :desc).page(params[:page]).per(100)
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
    @tag_names = ActsAsTaggableOn::Tagging.includes(:tag).where(context: :tags).all
                   .group_by{|t| t.tag.name }.map{|name,r| [name, r.size] }
                   .sort_by(&:last).reverse.map(&:first)

    result = {}
    ActsAsTaggableOn::Tagging.includes(:tag).group_by(&:taggable_id).each do |_,taggings|
      tag_names = taggings.select{|t| t.context == "tags" }.map{|t| t.tag.name }
      taggings.each do |t|
        next if t.context == "tags"
        result[t.tag.name] ||= {"guessed_tags_size" => 0, "size" => 0}
        result[t.tag.name]["guessed_tags_size"] += 1
        result[t.tag.name]["size"] += 1
        tag_names.each do |tag_name|
          result[t.tag.name][tag_name] ||= 0
          result[t.tag.name][tag_name] += 1
          result[t.tag.name]["size"] += 1
        end
      end
    end
    @summary = result.sort_by{|k,v| [-v["guessed_tags_size"], -v["size"]] }
                 .select{|k,v| params[:exclude_tagged].present? ? (v["guessed_tags_size"] == v["size"]) : true }
  end
end
