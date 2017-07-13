class AddLabelcolorToFields < ActiveRecord::Migration[5.0]
  def change
    add_column :fields, :labelcolor, :string
  end
end
