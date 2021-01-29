class AddFreeornotToPostes < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :freeornot, :integer
  end
end
