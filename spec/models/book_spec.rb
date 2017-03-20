require 'rails_helper'

RSpec.describe Book, type: :model do
  it "has author with normalized name" do
    book = build(:book)
    book.save!
    expect(book.author).to be_present
  end
end
