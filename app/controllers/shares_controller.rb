class SharesController < ApplicationController
    def create
        @card = Card.find_by id: params[:card_id]
        @rerender = false
        if is_expired(@card.expired) || @card.code.nil?
            @rerender = true
            share_name = Digest::SHA1.hexdigest("#{@current_user.id}|#{@card.id}|#{DateTime.now}")
            @card.update_attributes code: share_name, expired: 5.day.from_now
            File.open("./storage/#{share_name}.png", "wb") do|f|
                f.write(Base64.decode64(@card.thumb.gsub('data:image/png;base64,','')))
            end
        end
    end
    
    def show
        shared = false
        card = Card.find_by code: params[:id]
        respond_to do |format|
            format.html
            format.png { send_file("./storage/#{card.code}.png", {type: "image/png", disposition: "inline"})}
        end
    end

    private
    def is_expired des_time
        return true if des_time.nil?
        return DateTime.now > des_time
    end
end
