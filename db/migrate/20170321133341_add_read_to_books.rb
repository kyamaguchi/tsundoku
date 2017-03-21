class AddReadToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :read, :boolean
    add_index :books, :read
  end
end
