namespace :kindle do
  desc "Fetch kindle books list from amazon site with kindle_manager"
  task :fetch, [:limit,:new_dir] => :environment do |t, args|
    new_dir = args.new_dir == 'true'
    limit = (args.limit.presence || 100).to_i
    client = KindleManager::Client.new(debug: true, limit: limit, create: new_dir)
    books = client.fetch_kindle_list
  end

  desc "Import books from files generated with kindle_manager"
  task :import => :environment do |t, args|
    client = KindleManager::Client.new(debug: true)
    puts "Loading book data from #{client.store.dir_name}"
    books = client.load_kindle_books
    puts "Found #{books.size} books"
    books.each do |book|
      next if Book.where(asin: book.asin).exists?
      Book.create!(asin: book.asin, title: book.title, raw_author: book.author, tag: book.tag, date: book.date, collection_count: book.collection_count)
      puts "Create [#{book.title}]"
    end
    puts "#{Book.count} books in total"
  end
end

namespace :tags do
  desc "Guess tags from titles"
  task :guess_from_title => :environment do |t, args|
    Book.all.each do |book|
      book.guessed_tag_list.add Normalizer.extract_categories(book.title)[:categories]
      book.save!
    end
  end
end
