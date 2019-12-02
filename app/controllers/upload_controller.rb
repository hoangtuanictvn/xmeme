class UploadController < ApplicationController
    def index
        @resource = Resource.new
        @layout_options = CardLayout.all.collect{|lyt| [lyt.name, lyt.id]}
        @resources = Resource.all
    end

    def drop_resource
        @resource = Resource.find_by id: params[:id]
        if @resource.present?
            @resource.destroy
            redirect_to upload_path
        end
    end
end
