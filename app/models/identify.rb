class Identify < ApplicationRecord
    belongs_to :user, optional: true

    def self.find_by_omniauth omniauth
       find_by provider: omniauth['provider'], uid: omniauth['uid']
    end
end
