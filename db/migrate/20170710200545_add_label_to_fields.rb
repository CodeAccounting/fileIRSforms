class AddLabelToFields < ActiveRecord::Migration[5.0]
  def change
    add_column :fields, :label, :string
  end
end
