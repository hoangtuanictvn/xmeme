class CardsController < BaseNavigationController
    def edit
    end

    def new
        @layout = CardLayout.find_by id: params[:layout]
        @layout = CardLayout.new width: 512, height: 512, ratio: 1 unless @layout.present?
        @layouts = CardLayout.all
    end
end
