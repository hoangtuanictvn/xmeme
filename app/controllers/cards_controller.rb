class CardsController < BaseNavigationController
    def new
        @layout = CardLayout.find_by id: params[:layout]
        @layout = CardLayout.new width: 512, height: 512, ratio: 1 unless @layout.present?
        @layouts = CardLayout.all
    end

    def create
        
    end

    def edit
    end

    def update
    end
end
