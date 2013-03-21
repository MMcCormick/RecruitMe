class AddCodenameToUser < ActiveRecord::Migration
  def change
    add_column :users, :codename, :string
    add_index :users, :codename
  end
end
