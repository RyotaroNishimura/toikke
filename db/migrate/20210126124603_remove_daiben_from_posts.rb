class RemoveDaibenFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :Daiben, :integer
  end
end
