class Identify < ApplicationRecord
    belongs_to :user, optional: true

    def self.find_by_omniauth omniauth
       ident = find_by provider: omniauth['provider'], uid: omniauth['uid']
       if ident.present?
            p omniauth['credentials']['expires_at']
            ident.update_attributes access_token: omniauth['credentials']['token'],
                expired: omniauth['credentials']['expires_at'].try(:to_i),
                token_secret: omniauth['credentials']['secret']
       end
       return ident
    end
end
