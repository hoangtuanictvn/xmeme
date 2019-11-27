class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resources do |t|
      t.integer :resource_type
      t.string :data
      t.string :container
      t.string :format
      t.integer :card_layout_id

      t.timestamps
    end
  end
end
