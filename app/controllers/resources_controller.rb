class ResourcesController < ApplicationController

    def create
        @resource = Resource.new resource_params
        if @resource.save
            redirect_to upload_path
        else
            flash[:now] = "Errors"
        end
    end

    def index
    end

    def load
    end

    def upload
        @resource = Resource.new user_resources_params
        if @resource.save
            @resource.reload
            render json: { success: true, id: @resource.id, container: @resource.container, type: @resource.resource_type}, status: :created
        else
            render json: { success: false, errors: @resource.errors }, status: :unprocessable_entity
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
    
    def destroy
        @resource = Resource.find_by id: params[:id]
        if @resource.present?
            @resource.destroy
        end
    end

    private
    def resource_params
        params.require(:resource).permit :resource_type, :container, :card_layout_id
    end

    def user_resources_params
        params.require(:resource).permit :user_id, :container
    end
end
