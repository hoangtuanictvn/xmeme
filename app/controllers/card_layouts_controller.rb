class CardLayoutsController < ApplicationController
    def index
        @card_layouts = CardLayout.all.order('id asc')
    end

    def change
        @layout = CardLayout.find_by id: params[:layout_id]
        @card = Card.find_by id: params[:card_id]
        return unless @card.present? || @layout.present?

        if @card.card_layout_id != @layout.id
            @card.update_attributes card_layout_id: @layout.id, width: @layout.width, height: @layout.height
        end
    end
end
