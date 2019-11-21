class SessionsController < ApplicationController
    def create
        auth = request.env["omniauth.auth"]
        ident = Identify.find_by_omniauth auth
        unless ident.present?
            ident = Identify.new provider: auth['provider'], uid: auth['uid']
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
        current_user.forget
        current_user = nil
        redirect_to root_url, notice: "Signed out!"
    end

    def failure
    end
end
