class PostsEdit < ActiveRecord::Migration[5.2]
  def change
    change_column :Posts, :zaiko, :boolean
  end
end
