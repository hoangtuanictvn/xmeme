class AddFileNameToResource < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :file_name, :string
  end
end
