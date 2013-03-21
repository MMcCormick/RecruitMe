class AddDreamFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dream_salary, :integer
    add_column :users, :dream_move, :boolean
    add_column :users, :dream_management, :boolean
    add_column :users, :dream_size, :string
  end
end
