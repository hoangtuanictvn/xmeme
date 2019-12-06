class AddMusicResourceIdAndStrimTimeToCard < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :music_resource_id, :integer
    add_column :cards, :start_at, :time
    add_column :cards, :end_at, :time
  end
end
