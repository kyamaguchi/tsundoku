class RemoveReadFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_index :books, :read
    remove_column :books, :read, :boolean
  end
end
