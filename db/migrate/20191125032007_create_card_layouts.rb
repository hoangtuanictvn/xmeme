class CreateCardLayouts < ActiveRecord::Migration[6.0]
  def change
    create_table :card_layouts do |t|
      t.string :name
      t.string :description
      t.integer :width
      t.integer :height
      t.decimal :ratio

      t.timestamps
    end
  end
end
