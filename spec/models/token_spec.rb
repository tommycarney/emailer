require 'rails_helper'

RSpec.describe Token do

  let :auth_hash { OmniAuth.config.mock_auth[:google_oauth2] }

  it "from an auth parameter" do
    user = create(:user, email: "test@example.com")
    token = Token.from_omni_auth(auth_hash)
    allow(token).to receive(:revoke_token).and_return(true)
    expect(Token.find_by_email("test@example.com")).to eq(token)
  end

  it "should update an expired token" do
    token = Token.from_omni_auth(auth_hash)
    expect(token).to receive(:expired?).and_return(true)
    expect(token).to receive(:fetch_token_from_google).and_return(true)
    expect(token).to receive(:parse_data).and_return({"access_token"=> "updated_access_token", "expires_in"=> "3600"})
    token.update_token!
    expect(token.access_token).to eq("updated_access_token")
  end


end
