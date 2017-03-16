class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :asin
      t.string :title
      t.string :tag
      t.string :author
      t.date :date
      t.integer :collection_count

      t.timestamps
    end
    add_index :books, :asin, unique: true
  end
end
