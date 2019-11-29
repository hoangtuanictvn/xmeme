module SessionsHelper
    def remember user
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user
        if session[:user_id]
            @current_user ||= User.find_by id: session[:user_id]
        elsif user_id = cookies.signed[:user_id]
            user = User.find_by id: user_id
            if user&.authenticated? :remember, cookies[:remember_token]
              signin user
              @current_user = user
            end
        end
    end

    def authenticated?
        redirect_to root_url, notice: "Something wrong" unless signed_in? 
    end

    def signed_in?
      !!current_user
    end

    def sign_in ident
        if ident.try(:user).present?
            update_current_user ident.user
            ident.user.remember
            if ident.try(:user).first_time
                redirect_to layouts_path, :notice => "Signed in!"
            else
                redirect_to cards_path, :notice => "Signed in!"
            end
        else
            redirect_to root_url, notice: "Something wrong"
        end
    end

    def update_current_user user
      @current_user = user
      session[:user_id] = user.id
    end    
end