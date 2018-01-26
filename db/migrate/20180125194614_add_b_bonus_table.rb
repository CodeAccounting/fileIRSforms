class AddBBonusTable < ActiveRecord::Migration[5.0]
  def change
    create_table :bonus do |t|
      t.string :code
      t.string :email
      t.timestamps
    end
  end
end
