class AddExpiredToCard < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :expired, :timestamp
  end
end
