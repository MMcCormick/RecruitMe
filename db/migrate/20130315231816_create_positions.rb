class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :company_uid
      t.integer :uid
      t.integer :user_id
      t.string :company_industry
      t.string :company_name
      t.string :company_type
      t.string :company_size
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_current
    end
  end
end
