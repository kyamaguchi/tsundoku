require 'rails_helper'

RSpec.describe Author, type: :model do
  it "should be unique with name" do
    create(:author, name: 'Test')
    expect{
      create(:author, name: 'Test')
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "has many books" do
    create(:book, raw_author: 'Test')
    create(:book, raw_author: 'Test')
    expect(Author.find_by(name: 'Test').books.size).to eql(2)
  end
end
