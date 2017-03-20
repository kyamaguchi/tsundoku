class RenameAuthorColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :books, :author, :raw_author
  end
end
