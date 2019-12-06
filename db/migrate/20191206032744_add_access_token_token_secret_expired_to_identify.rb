class AddAccessTokenTokenSecretExpiredToIdentify < ActiveRecord::Migration[6.0]
  def change
    add_column :identifies, :access_token, :string
    add_column :identifies, :token_secret, :string
    add_column :identifies, :expired, :timestamp
  end
end
