class CreateForms < ActiveRecord::Migration[5.0]
  def change
    create_table :forms do |t|
      t.string :field_name
      t.text :field_value
      t.integer :user_id

      t.timestamps
    end
  end
end
