class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.integer :type
      t.text :data
      t.string :hash
      t.json :format
      t.integer :render_status
      t.string :url
      t.text :thumb
      t.decimal :width
      t.decimal :height
      t.boolean :is_template
      t.integer :card_layout_id
      t.integer :user_id

      t.timestamps
    end
  end
end
