class ImageRenderService
    def self.render card, user_id, uploaded=true
        Cloudinary::Uploader.destroy(card.code) unless card.code.nil?
        expi = 5.day.from_now
        share_name = Digest::SHA1.hexdigest("#{user_id}|#{card.id}|#{expi}")
        card.update_attributes expired: expi
        file = File.open("./storage/#{share_name}.png", "wb") do|f|
            f.write(Base64.decode64(card.thumb.gsub('data:image/png;base64,','')))
        end
        if uploaded
            res = Cloudinary::Uploader.upload("./storage/#{share_name}.png", {
                public_id: share_name
            })
            File.delete("./storage/#{share_name}.png");
            return share_name, res['secure_url']
        end
        return "./storage/#{share_name}.png"
    end

    def self.render_image card, uploaded=true
        Cloudinary::Uploader.destroy(card.code) unless card.code.nil?
        file = File.open("./storage/#{card.code}.png", "wb") do|f|
            f.write(Base64.decode64(card.thumb.gsub('data:image/png;base64,','')))
        end
        if uploaded
            res = Cloudinary::Uploader.upload("./storage/#{card.code}.png", {
                public_id: card.code
            })
            File.delete("./storage/#{card.code}.png");
            return card.code, res['secure_url']
        end
        return "./storage/#{card.code}.png"
    end
end
