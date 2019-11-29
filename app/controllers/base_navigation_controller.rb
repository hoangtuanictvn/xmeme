class BaseNavigationController < ApplicationController
    layout "navigation"
    before_action :authenticated?
end
