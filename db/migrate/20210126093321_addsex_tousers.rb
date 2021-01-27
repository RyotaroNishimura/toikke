class AddsexTousers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sex, :integer
  end
end
