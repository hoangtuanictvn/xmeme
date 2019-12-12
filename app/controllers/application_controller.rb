class ApplicationController < ActionController::Base
    include SessionsHelper
    helper_method :current_user, :signed_in?
end
