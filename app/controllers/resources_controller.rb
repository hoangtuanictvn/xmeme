class ResourcesController < ApplicationController
    def add
        @type = params[:add]
        @type = "none" if @type.nil?
        @layouts = CardLayout.all
    end
end
