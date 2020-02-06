class AddColumnTitles < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :option, :string
  end
end
