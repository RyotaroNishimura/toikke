class AddAdressToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :adress, :string
  end
end
