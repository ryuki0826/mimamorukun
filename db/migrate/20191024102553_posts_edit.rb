class PostsEdit < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :zaiko, :boolean
  end
end
