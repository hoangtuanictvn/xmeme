class SharesController < ApplicationController
    before_action :signed_in?, only: [:create]
    def create
        @card = Card.find_by id: params[:card_id]
        @rerender = false
        if is_expired(@card.expired) || @card.code.nil?
            res = ImageRenderService.render(@card, @current_user.id)
            unless res.nil?
                @card.update_attributes code: res[0], data: res[1]
                @rerender = true
            end
        end
    end
    
    def show
        shared = false
        card = Card.find_by code: params[:id]

        redirect_to root_path and return unless card.present?

        unless valid_card? card, params[:id]
            Cloudinary::Uploader.destroy(card.code) unless card.code.nil?
            card.update_attributes code: nil, expired: nil
            redirect_to story_card
        end

        respond_to do |format|
            format.html
            format.png { send_data(open(card.data).read, {type: "image/png", disposition: "inline"})}
            format.mp4 { send_data(open(card.url).read, :disposition => 'inline', :stream => true) }
        end
    end

    def story
        @card = Card.find_by code: params[:share_id]
        redirect_to root_path unless @card.present?
        unless valid_card? @card, params[:share_id]
            Cloudinary::Uploader.destroy(@card.code) unless @card.code.nil?
            @card.update_attributes code: nil, expired: nil
            redirect_to root_path
        end
    end

    private
    def is_expired des_time
        return true if des_time.nil?
        return DateTime.now > des_time
    end

    def valid_card? card, token
        card_valid = Digest::SHA1.hexdigest("#{card.user.id}|#{card.id}|#{card.expired}")
        return card_valid.eql? token
    end
end
