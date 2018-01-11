class AddBonusColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bonus, :integer, default: 0
  end
end
