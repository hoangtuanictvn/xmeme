class SharesController < ApplicationController
<<<<<<< Updated upstream
    before_action :signed_in?, only: [:create]
=======
>>>>>>> Stashed changes
    def create
        @card = Card.find_by id: params[:card_id]
        @rerender = false
        if is_expired(@card.expired) || @card.code.nil?
<<<<<<< Updated upstream
            res = ImageRenderService.render(@card, @current_user.id)
            unless res.nil?
                @card.update_attributes code: res[0], data: res[1]
                @rerender = true
=======
            @rerender = true
            share_name = Digest::SHA1.hexdigest("#{@current_user.id}|#{@card.id}|#{DateTime.now}")
            @card.update_attributes code: share_name, expired: 5.day.from_now
            File.open("./storage/#{share_name}.png", "wb") do|f|
                f.write(Base64.decode64(@card.thumb.gsub('data:image/png;base64,','')))
>>>>>>> Stashed changes
            end
        end
    end
    
    def show
        shared = false
        card = Card.find_by code: params[:id]
<<<<<<< Updated upstream

        redirect_to root_path unless card.present?

        unless valid_card card, params[:id]
            Cloudinary::Uploader.destroy(card.code) unless card.code.nil?
            card.update_attributes code: nil, expired: nil
            redirect_to root_path
        end

        respond_to do |format|
            format.html
            format.png { send_data(open(card.data).read, {type: "image/png", disposition: "inline"})}
        end
    end

    def story
        @card = Card.find_by code: params[:share_id]
        redirect_to root_path unless @card.present?
        unless valid_card @card, params[:share_id]
            Cloudinary::Uploader.destroy(@card.code) unless @card.code.nil?
            @card.update_attributes code: nil, expired: nil
            redirect_to root_path
=======
        respond_to do |format|
            format.html
            format.png { send_file("./storage/#{card.code}.png", {type: "image/png", disposition: "inline"})}
>>>>>>> Stashed changes
        end
    end

    private
    def is_expired des_time
        return true if des_time.nil?
        return DateTime.now > des_time
    end
<<<<<<< Updated upstream

    def valid_card card, token
        card_valid = Digest::SHA1.hexdigest("#{card.user.id}|#{card.id}|#{card.expired}")
        return card_valid.eql? token
    end
=======
>>>>>>> Stashed changes
end
