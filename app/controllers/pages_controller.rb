class PagesController < ApplicationController
    before_action :check_signed_in?

    def index
        if valid_page?
            render template: "pages/#{params[:page]}"
        else
            render file: "public/404.html", status: :not_found
        end
    end

    private
    def valid_page?
        File.exist? Pathname.new(Rails.root + "app/views/pages/#{params[:page]}.html.erb")
    end
    
    private
    def check_signed_in?
        redirect_to cards_path if signed_in?
    end
end
