module ApplicationHelper
    def parent_class
        "#{self.controller_name}#{params[:page]&.nil? ? "" : "-"}#{params[:page]}"
    end

    def app_title
        
    end
end
