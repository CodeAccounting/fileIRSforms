class AddingUniqueidColumnInFieldsTable < ActiveRecord::Migration[5.0]
  def change
        add_column :fields, :unique_id, :string  
  end
end
