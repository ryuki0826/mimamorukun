class AddToZaikoPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :zaiko, :string
  end
end
