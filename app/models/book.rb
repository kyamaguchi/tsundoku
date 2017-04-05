class Book < ApplicationRecord
  paginates_per 100

  belongs_to :author

  acts_as_taggable_on :guessed_tags, :tags

  before_validation :set_author

  validates_uniqueness_of :asin
  validates_presence_of :asin, :title

  def as_json(options={})
    super().merge({
      tag: (tag.presence || 'None'),
      read: (!!read ? 'Y' : 'N'),
    })
  end

  private

    def set_author
      self.author = Author.with_normalized_name(self.raw_author).first_or_create!
    end
end
