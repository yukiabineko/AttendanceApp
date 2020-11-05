class CreateMonths < ActiveRecord::Migration[5.2]
  def change
    create_table :months do |t|
      t.string :request_month
      t.string :superior_name
      t.integer :permit_month,default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
