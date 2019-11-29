class AddFirstTimeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_time, :boolean
  end
end
