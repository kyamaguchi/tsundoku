namespace :kindle do
  desc "Import books from files generated with kindle_manager"
  task :import => :environment do |t, args|
    client = KindleManager::Client.new(debug: true)
    books = client.load_kindle_books
    puts "Found #{books.size} books"
    books.each do |book|
      next if Book.where(asin: book.asin).exists?
      Book.create(asin: book.asin, title: book.title, author: book.author, tag: book.tag, date: book.date, collection_count: book.collection_count)
    end
    puts "#{Book.count} books in total"
  end
end