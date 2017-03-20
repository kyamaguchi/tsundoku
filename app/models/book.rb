class Book < ApplicationRecord
  paginates_per 100

  belongs_to :author

  before_validation :set_author

  validates_uniqueness_of :asin
  validates_presence_of :asin, :title

  private

    def set_author
      self.author = Author.where(name: self.raw_author).first_or_create!
    end
end
