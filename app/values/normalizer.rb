class Normalizer

  def self.normalize(str)
    str.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z').gsub(/[\s　]+/,'')
  end
end
