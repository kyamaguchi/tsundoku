class Author < ApplicationRecord
  has_many :books

  validates_uniqueness_of :name

  before_validation :normalize_name

  scope :with_normalized_name, -> (name){ where(name: normalize(name)) }

  def self.normalize(name)
    name.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z').gsub(/[\s　]+/,'')
  end

  private

    def normalize_name
      self.name = self.class.normalize(name)
    end
end
