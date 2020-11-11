class AddpriceTOposts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :price, :integer
  end
end
