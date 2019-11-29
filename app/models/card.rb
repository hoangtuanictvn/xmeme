class Card < ApplicationRecord
    belongs_to :card_layout
    belongs_to :user
end
