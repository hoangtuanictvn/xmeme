class ApplicationController < ActionController::Base
    before_action :signed_in?
    include SessionsHelper
    helper_method :current_user, :signed_in?
end
