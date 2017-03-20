require 'rails_helper'

RSpec.describe Book, type: :model do
  it "has author with normalized name" do
    book = build(:book, raw_author: 'Test A')
    book.save!
    expect(book.author).to be_present
    expect(book.author.name).to eql('TestA')

    create(:book, raw_author: 'Test B')
    expect(Author.count).to eql(2)
  end
end
