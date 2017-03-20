class CreateAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :authors do |t|
      t.string :name

      t.timestamps
    end
    add_index :authors, :name
  end
end
