class SharesController < ApplicationController
    before_action :signed_in?, only: [:create]
    def create
        @card = Card.find_by id: params[:card_id]
        @rerender = false
        if is_expired(@card.expired) || @card.code.nil?
            ImageRenderService.render(@card, @current_user.id)
            @rerender = true
        end
    end
    
    def show
        shared = false
        card = Card.find_by code: params[:id]

        redirect_to card_edit_path(card) unless card.present?

        unless valid_card card, params[:id]
            card.update_attributes code: nil, expired: nil
            redirect_to root_path
        end

        respond_to do |format|
            format.html
            format.png { send_file("./storage/#{card.code}.png", {type: "image/png", disposition: "inline"})}
        end
    end

    def story
        @card = Card.find_by code: params[:share_id]
        redirect_to root_path unless @card.present?
        unless valid_card @card, params[:share_id]
            @card.update_attributes code: nil, expired: nil
            redirect_to root_path
        end
    end

    private
    def is_expired des_time
        return true if des_time.nil?
        return DateTime.now > des_time
    end

    def valid_card card, token
        card_valid = Digest::SHA1.hexdigest("#{card.user.id}|#{card.id}|#{card.expired}")
        return card_valid.eql? token
    end
end
