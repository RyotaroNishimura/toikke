class AddSyobenToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :syoben, :integer
  end
end
