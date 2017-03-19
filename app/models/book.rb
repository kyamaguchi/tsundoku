class Book < ApplicationRecord
  paginates_per 100

  validates_uniqueness_of :asin
  validates_presence_of :asin, :title
end
