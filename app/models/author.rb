class Author < ApplicationRecord
  has_many :books

  validates_uniqueness_of :name
end
