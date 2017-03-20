require 'rails_helper'

RSpec.describe Author, type: :model do
  it "should be unique with name" do
    create(:author, name: 'Test')
    expect{
      create(:author, name: 'Test')
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should normalize name" do
    author = create(:author, name: 'Test A')
    expect(author.name).to eql('TestA')
  end

  it "has many books" do
    create(:book, raw_author: 'Test A')
    create(:book, raw_author: 'TestA ')
    expect(Author.find_by(name: 'TestA').books.size).to eql(2)
    expect(Author.count).to eql(1)
  end
end
