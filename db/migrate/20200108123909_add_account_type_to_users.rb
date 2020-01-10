class AddAccountTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account, :integer
  end
end
