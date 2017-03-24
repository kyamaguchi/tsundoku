class Normalizer

  def self.normalize(str)
    halfsize(str).gsub(/[\s　]+/,'')
  end

  def self.halfsize(str)
    str.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end

  def self.extract_categories(str)
    categories = []

    [
      ['(', ')'],
      ['<', '>'],
      ['[', ']'],

      ['（', '）'],
      ['［', '］'],
      ['【', '】'],
      ['─', '─'],
    ].each do |open, close|
      re = /#{Regexp.escape(open)}(.+?)#{Regexp.escape(close)}/
      str.scan(re).each do |word|
        categories << halfsize(word.first)
      end
      str = str.gsub(re, '_')
    end

    # Extract number
    number_re = '([0-9０-９]+)'
    unit_re = '(巻)?'
    [/#{number_re}#{unit_re}[ 　_]*\z/, /[ 　_]+#{number_re}#{unit_re}[ 　_]+/].each do |re|
      m = str.match(re)
      if m
        categories << halfsize(m[1])
        str = str.gsub(re, '_')
      end
    end

    {rest: str, categories: categories}
  end
end
