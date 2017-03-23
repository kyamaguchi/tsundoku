require 'rails_helper'

RSpec.describe Normalizer, type: :model do
  describe '.normalize' do
    it "normalizes a word including spaces" do
      expect(Normalizer.normalize('Test A')).to eql('TestA')
      expect(Normalizer.normalize('Test ')).to eql('Test')
      expect(Normalizer.normalize(' Test')).to eql('Test')
    end

    it "normalizes a word including zenkaku space" do
      expect(Normalizer.normalize('Test　A')).to eql('TestA')
    end

    it "normalizes a word including zenkaku" do
      expect(Normalizer.normalize('Ｔｅｓｔ１２３')).to eql('Test123')
    end
  end
end
