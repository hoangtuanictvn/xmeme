class AddNameAndFirstTimeToCard < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :name, :string
    add_column :cards, :first_time, :boolean, default: true
  end
end
