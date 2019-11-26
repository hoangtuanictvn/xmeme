class CardLayoutsController < ApplicationController
    def index
        @card_layouts = CardLayout.all.order('id asc')
    end
end
