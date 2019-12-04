class User < ApplicationRecord
  attr_reader :remember_token
  has_many :identifies
  has_many :cards
  has_many :resources

  def self.create_by_omniauth auth
    create! do |user|
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.picture = auth["info"]["image"]
    end
  end

  def current_user? user
    self == user
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def remember
    @remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def forget
    update_attributes remember_digest: nil
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
