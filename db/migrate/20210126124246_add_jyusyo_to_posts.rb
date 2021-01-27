class AddJyusyoToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :Jyusyo, :string
  end
end
