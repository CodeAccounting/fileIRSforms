class ChangeColumnTypeInFields < ActiveRecord::Migration[5.0]
  def change
    change_column :fields, :form_id, :text
  end
end
