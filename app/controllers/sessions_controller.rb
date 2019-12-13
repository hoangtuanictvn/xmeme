class SessionsController < ApplicationController
    before_action :signed_in?
    
    def create
        auth = request.env["omniauth.auth"]
        ident = Identify.find_by_omniauth auth
        p auth.to_json
        unless ident.present?
            ident = Identify.new provider: auth['provider'], 
                uid: auth['uid'], 
                access_token: auth['credentials']['token'],
                token_secret: auth['credentials']['secret'],
                expired: auth['credentials']['expires_at']
            if ident.save
                unless ident.try(:user).present?
                    user = User.create_by_omniauth auth
                    if user.present?
                        ident.update_attributes user_id: user.id
                        sign_in ident
                    else
                        redirect_to root_url, :notice => "Some thing wrong!"
                    end
                else
                    sign_in ident
                end
            else
                redirect_to root_url, :notice => "Some thing wrong!"
            end
        else
            sign_in ident
        end
    end

    def destroy
        @current_user.forget
        @current_user = nil
        session[:user_id] = nil
        redirect_to root_url, notice: "Signed out!"
    end

    def failure
    end
end
