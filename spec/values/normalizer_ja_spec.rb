require 'rails_helper'

RSpec.describe "Normalizer for Japanese title", type: :model do
  describe '.extract_categories' do
    it 'extracts category from parentheses' do
      title = 'DRAGON BALL カラー版 孫悟空修業編 1 (ジャンプコミックスDIGITAL)'
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to include('ジャンプコミックスDIGITAL')
      expect(result[:rest]).to_not match(/ジャンプコミックスDIGITAL/)
      expect(result[:rest]).to match(/DRAGON/)
    end

    it 'extracts category from angle brackets' do
      title = '機動戦士ガンダム THE ORIGIN(1)<機動戦士ガンダム THE ORIGIN> (角川コミックス・エース)'
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to include(*['1', '機動戦士ガンダム THE ORIGIN', '角川コミックス・エース'])
      expect(result[:rest]).to_not match(/</)
      expect(result[:rest]).to match(/機動戦士ガンダム/)
    end

    it 'extracts category from half-width square brackets' do
      title = "ＷＨＡＴ'ｓ ＩＮ? (ワッツイン) 2015年 3月号 [雑誌]"
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to include('雑誌')
    end

    it 'extracts category from full-width square brackets' do
      title = 'Discover Japan 2017年1月号 Vol.63［雑誌］'
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to include('雑誌')
    end

    it 'extracts category from full-width parentheses' do
      title = '進撃の巨人（１） (週刊少年マガジンコミックス)'
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to include('1')
    end

    it 'extracts category from thick square brackets' do
      title = '進撃の巨人【特典つき】（１７）'
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to include(*['特典つき', '17'])
    end

    it 'extracts category from special hyphens' do
      title = '論語　─まんがで読破─'
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to include('まんがで読破')
    end

    it "doesn't raise error when patterns don't match" do
      title = 'デッドライン'
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to be_empty
      expect(result[:rest]).to eql(title)
    end

    it "converts the category word with full-width characters to half-width" do
      title = 'なぜあなたの予測は外れるのか　AIが起こすデータサイエンス革命 (扶桑社ＢＯＯＫＳ)'
      result = Normalizer.extract_categories(title)
      expect(result[:categories]).to include('扶桑社BOOKS')
    end

    context 'number' do
      it 'extracts number at the end' do
        ['アドルフに告ぐ　1', '新ブラックジャックによろしく１'].each do |title|
          result = Normalizer.extract_categories(title)
          expect(result[:categories]).to include('1')
        end
      end

      it 'extracts number with volume at the end' do
        title = 'エマ 1巻<エマ> (ビームコミックス（ハルタ）)'
        result = Normalizer.extract_categories(title)
        expect(result[:categories]).to include('1')
      end

      it 'extracts number in the middle of title' do
        title = '賭博堕天録 カイジ　１ 賭博堕天録カイジ'
        result = Normalizer.extract_categories(title)
        expect(result[:categories]).to include('1')
      end
    end
  end
end
