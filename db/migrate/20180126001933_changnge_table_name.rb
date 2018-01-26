class ChangngeTableName < ActiveRecord::Migration[5.0]
  def change
    rename_table :bonus, :referring
  end
end
