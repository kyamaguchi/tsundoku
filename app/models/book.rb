class Book < ApplicationRecord
  validates_uniqueness_of :asin
  validates_presence_of :asin, :title
end
