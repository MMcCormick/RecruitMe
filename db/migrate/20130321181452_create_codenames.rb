class CreateCodenames < ActiveRecord::Migration
  def change
    create_table :codenames do |t|
      t.string :name
      t.boolean :used, :default => false
    end

    add_index :codenames, :name, :unique => true
  end
end
