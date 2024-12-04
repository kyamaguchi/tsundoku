class ChangeUniqueIndexOnBooks < ActiveRecord::Migration[6.1]
  def change
    remove_index :books, name: "index_books_on_asin"

    add_index :books, [:asin, :tag], unique: true, name: "index_books_on_asin_and_tag"
  end
end
