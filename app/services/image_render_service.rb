class ImageRenderService
    def self.render card, user_id
        expi = 5.day.from_now
        share_name = Digest::SHA1.hexdigest("#{user_id}|#{card.id}|#{expi}")
        card.update_attributes code: share_name, expired: expi
        file = File.open("./storage/#{share_name}.png", "wb") do|f|
            f.write(Base64.decode64(card.thumb.gsub('data:image/png;base64,','')))
        end
        share_name
    end
end
