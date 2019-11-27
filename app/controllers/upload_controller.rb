class UploadController < ApplicationController
    def index
        @resource = Resource.new
        @layout_options = CardLayout.all.collect{|lyt| [lyt.name, lyt.id]}
    end
end
