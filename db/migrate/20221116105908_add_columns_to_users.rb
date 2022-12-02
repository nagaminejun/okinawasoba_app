class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :line_user_id, :string, index: { unique: true }
  end
end
