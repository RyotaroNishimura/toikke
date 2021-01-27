class AddUnnkoToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :unnko, :integer
  end
end
