class ResourcesController < ApplicationController
    def create
        @resource = Resource.new resource_params
        if @resource.save
            redirect_to upload_path
        else
            flash[:now] = "Errors"
        end
    end

    def add
        @type = params[:add]
        @type = "none" if @type.nil?
        @layouts = CardLayout.all
        @resources = Resource.where(resource_type: @type)
    end

    def insert
        # @type = params[:type]
        # return if @type.nil?
    end

    private
    def resource_params
        params.require(:resource).permit :resource_type, :container, :card_layout_id
    end
end
