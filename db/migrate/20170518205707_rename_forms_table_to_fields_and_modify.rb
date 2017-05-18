class RenameFormsTableToFieldsAndModify < ActiveRecord::Migration[5.0]
  def self.up
    rename_table :forms, :fields
    add_column :fields, :form_id, :integer  
  end

  def self.down
    remove_column :fields, :form_id
    rename_table :fields, :forms
  end
end
