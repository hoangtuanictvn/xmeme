class ImageRenderService
    def self.render card, uploaded=true
        Cloudinary::Uploader.destroy(card.code) unless card.code.nil?
        path = File.join Rails.root, "storage"
        File.mkdir(path) unless File.exist?(path) 
        file = File.open(File.join(path, "#{card.code}.png"), "wb") do|f|
            f.write(Base64.decode64(card.thumb.gsub('data:image/png;base64,','')))
        end
        if uploaded == true
            res = Cloudinary::Uploader.upload(File.join(path, "#{card.code}.png"), {
                public_id: card.code
            })
            File.delete(File.join(path, "#{card.code}.png"));
            card.update_attributes data: res['secure_url']
            return card.code, res['secure_url']
        end
        return File.join(path, "#{card.code}.png")
    end
end
