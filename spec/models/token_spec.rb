require 'rails_helper'

RSpec.describe Token do
  let :authhash {
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      :provider => 'google_oauth2',
      :uid => '123545',
      :credentials => {
                       :refresh_token => '12345',
                       :token         => '54321',
                       :expires_at    => 1.hour.from_now
                     },

      :info        =>  {
                       :email         => 'test@example.com'
      }
    })
  }

  it "creates a token from an auth parameter" do
    token = Token.from_omni_auth(authhash)
    allow(token).to receive(:revoke_token).and_return(true)
    expect(Token.find_by_email("test@example.com")).to eq(token)
  end

  it "should update an expired token" do
    token = Token.from_omni_auth(authhash)
    allow(token).to receive(:revoke_token).and_return(true)
    allow(token).to receive(:expired?).and_return(true)
    allow(token).to receive(:fetch_token_from_google).and_return(true)
    allow(token).to receive(:parse_data).and_return({"access_token"=> "updated_access_token", "expires_in"=> "3600"})
    token.update_token!
    expect(token.access_token).to eq("updated_access_token")
  end

end
