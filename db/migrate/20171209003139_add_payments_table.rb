class AddPaymentsTable < ActiveRecord::Migration[5.0]
  def change
     create_table :payments do |t|
      t.string :unique_id
      t.integer :user_id
      t.string :status

      t.timestamps
     end
  end
end
