class PostsEdit < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :zaiko, 'boolean USING CAST(zaiko AS boolean)'
  end
end
