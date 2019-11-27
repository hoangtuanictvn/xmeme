class Resource < ApplicationRecord
    belongs_to :card_layout
    mount_uploader :container, ResourceUploader
    enum resource_type: [:image, :sticker, :font, :music, :text]
    after_initialize :set_default_type, if: :new_record?

    def set_default_type
        self.resource_type ||= :image
    end
end
