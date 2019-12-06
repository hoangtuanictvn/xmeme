class Card < ApplicationRecord
    belongs_to :card_layout
    belongs_to :user
    belongs_to :music, class_name: "Resource", foreign_key: 'music_resource_id', optional: true
end
