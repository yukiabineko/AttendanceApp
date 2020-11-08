class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.integer :number
      t.string :name
      t.string :category

      t.timestamps
    end
  end
end
