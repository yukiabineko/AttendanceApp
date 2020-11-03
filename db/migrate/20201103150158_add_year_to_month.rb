class AddYearToMonth < ActiveRecord::Migration[5.2]
  def change
    add_column :months, :year, :string
  end
end
