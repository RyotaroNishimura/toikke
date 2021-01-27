class AddDaibenToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :Daiben, :integer
  end
end
