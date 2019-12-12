class Card < ApplicationRecord
    belongs_to :card_layout
    belongs_to :user
    belongs_to :music, class_name: "Resource", foreign_key: 'music_resource_id', optional: true
    enum render_status: [:nonqueue, :pending, :inprogress, :failed, :success]
    after_initialize :set_default_status, if: :new_record?

    def set_default_status
        self.render_status ||= :nonqueue
    end
end
