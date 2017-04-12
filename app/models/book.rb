class Book < ApplicationRecord
  paginates_per 100

  belongs_to :author

  acts_as_taggable_on :guessed_tags, :tags

  before_validation :set_author

  validates_uniqueness_of :asin
  validates_presence_of :asin, :title

  def as_json(options={})
    attrs = {
      tag: (tag.presence || 'None'),
      read: (!!read ? 'Y' : 'N'),
      guessed_tag_list: guessed_tags.map(&:name).presence || [],
      tag_list: tags.map(&:name).presence || ['None'],
    }
    options.fetch(:tag_ids, []).each do |id|
      attrs["tag_list#{id}"] = tags.find{|e| e.id == id }.present? ? 'Y' : 'N'
    end
    super().merge(attrs)
  end

  private

    def set_author
      self.author = Author.with_normalized_name(self.raw_author).first_or_create!
    end
end
