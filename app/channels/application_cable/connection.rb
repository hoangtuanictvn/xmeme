module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
 
    def connect
      self.current_user = find_verified_user
    end

    private
    def find_verified_user
      if verified_user = verify_user
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def verify_user
      if request.session[:user_id]
        return User.find_by id: request.session[:user_id]
      elsif user_id = cookies.signed[:user_id]
        user = User.find_by id: user_id
        if user&.authenticated? :remember, cookies[:remember_token]
          return user
        end
      end
    end
  end
end
