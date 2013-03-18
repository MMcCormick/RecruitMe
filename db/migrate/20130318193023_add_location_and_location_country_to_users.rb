class AddLocationAndLocationCountryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location_name, :string
    add_column :users, :country_code, :string
  end
end