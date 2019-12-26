class ImageRenderService
    def self.render card, user_id, uploaded=true
        Cloudinary::Uploader.destroy(card.code) unless card.code.nil?
        Dir.mkdir("#{Rails.root}/storage") unless File.exists?("#{Rails.root}/storage")
        file = File.open("./storage/#{card.code}}.png", "wb") do|f|
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
