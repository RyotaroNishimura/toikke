class RemoveJyushoFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :Jyusyo, :string
  end
end
