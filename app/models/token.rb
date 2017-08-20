require 'net/http'
require 'json'

class Token < ActiveRecord::Base
  before_destroy :revoke_token
  belongs_to :user, primary_key: "email", foreign_key: "email"

  def self.from_omni_auth(auth)
    where(email: auth.info.email).first_or_create do |token|
      token.access_token = auth.credentials.token,
      token.refresh_token = auth.credentials.refresh_token,
      token.expires_at = Time.at(auth.credentials.expires_at).to_datetime,
      token.email = auth.info.email
    end
  end

  def update_token
    refresh! if expired?
  end

  private

  def to_params
    {'refresh_token'  => refresh_token,
      'client_id'     => Rails.application.secrets.client_id,
      'client_secret' => Rails.application.secrets.client_secret,
      'grant_type'    => 'refresh_token'
    }
  end

    def refresh!
      response = fetch_token_from_google
      data = JSON.parse(response.body)
      update_attributes(
        access_token: data['access_token'],
        expires_at: Time.now + (data['expires_in'].to_i).seconds)
    end

    def expired?
      expires_at < Time.now
    end

    def fetch_token_from_google
      url = URI("https://accounts.google.com/o/oauth2/token")
      Net::HTTP.post_form(url, to_params)
    end

    def revoke_token
      uri = URI('https://accounts.google.com/o/oauth2/revoke')
      params = { :token => self.access_token }
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get(uri)
    end
end
