class CardsController < BaseNavigationController
    def index
        @cards = @current_user.cards
    end

    def create
        @card = Card.new card_layout_id: params[:layout_id], user_id: params[:uid]
        return unless @card.save
    end

    def edit
        @card = Card.find_by id: params[:id]
        @layout = @card.card_layout
        @layouts = CardLayout.all
        @resource = Resource.new
    end

    def update
        @card = Card.find_by id: params[:id]
        if @card.present?
            @card.update_attributes format: params[:format], thumb: params[:thumb]
        end
    end

    def generate
        @card = Card.find_by id: params[:card_id]
        return unless @card.music.present?
        if @card.code.nil?
            expi = 5.day.from_now
            share_name = Digest::SHA1.hexdigest("#{@card.user_id}|#{@card.id}|#{expi}")
            @card.update_attributes expired: expi, code: share_name
        end
        if @card.present? && (@card.success? || @card.nonqueue?)
            @card.update_attributes render_status: :pending
            VideoRenderWorker.perform_async(@current_user.id, @card.id)
        end
    end

    def thumb
        card = Card.find_by id: params[:card_id]
        respond_to do |format|
            format.png { send_data(Base64.decode64(card.thumb.gsub('data:image/png;base64,','')), {type: "image/png", disposition: "inline"})}
        end
    end

    def detach_music
        @card = Card.find_by id: params[:card_id]
        return unless @card.music.present?
        @card.update_attributes music_resource_id: nil
    end

    def destroy
        @card = Card.find_by id: params[:id]
        if @card.present?
            @card.destroy
            redirect_to cards_path
        end
    end
end
