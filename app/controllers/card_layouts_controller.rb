class CardLayoutsController < ApplicationController
    def index
        @card_layouts = CardLayout.all.order('id asc')
    end

    def change
        @layout = CardLayout.find_by id: params[:id]
    end
end
