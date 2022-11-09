class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :store_name
      t.string :menu
      t.integer :price
      t.text :comment
      t.string :image
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
