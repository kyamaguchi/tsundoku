class Author < ApplicationRecord
  has_many :books

  validates_uniqueness_of :name

  before_validation :normalize_name

  scope :with_normalized_name, -> (name){ where(name: Normalizer.normalize(name)) }

  private

    def normalize_name
      self.name = Normalizer.normalize(name)
    end
end
