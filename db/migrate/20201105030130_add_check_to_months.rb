class AddCheckToMonths < ActiveRecord::Migration[5.2]
  def change
    add_column :months, :check, :boolean, default: false
    add_column :months, :base_day, :date
  end
end
