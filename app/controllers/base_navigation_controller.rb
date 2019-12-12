class BaseNavigationController < ApplicationController
    layout "navigation"
    before_action :signed_in?
    before_action :authenticated?
end
