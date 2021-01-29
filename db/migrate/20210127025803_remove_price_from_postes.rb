class RemovePriceFromPostes < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :price, :string
  end
end
