class Resource < ApplicationRecord
    belongs_to :card_layout, optional: true
    belongs_to :user, optional: true
    has_many :cards
    mount_uploader :container, ResourceUploader
    enum resource_type: [:image, :sticker, :font, :music, :text]
    after_initialize :set_default_type, if: :new_record?
    before_save :update_asset_attributes

    def update_asset_attributes
        if container.present? && container_changed?
            # if %w{jpg png jpg gif bmp}.include?(container.file.extension)
            #     self.resource_type = "image"
            # els
            if %w{mp3 wav}.include?(container.file.extension)
                self.resource_type = "music"
            end
            self.file_name = File.basename(container.normal_name, ".*") if container.normal_name.present?
        end
    end

    def set_default_type
        self.resource_type ||= :image
    end
end
