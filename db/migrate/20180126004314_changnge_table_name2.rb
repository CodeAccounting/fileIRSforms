class ChangngeTableName2 < ActiveRecord::Migration[5.0]
  def change
    rename_table :referring, :referrings
  end
end
