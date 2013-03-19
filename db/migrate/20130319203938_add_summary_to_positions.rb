class AddSummaryToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :summary, :text
    change_column :positions, :start_date, :date
    change_column :positions, :end_date, :date
  end
end
