require 'rails_helper'

RSpec.describe User do

  let :auth_hash { OmniAuth.config.mock_auth[:google_oauth2] }

  it "creates a user from an auth hash from devise" do
    user = User.from_omni_auth(auth_hash)
    expect(User.find_by_email("test@example.com")).to eq(user)
  end

  it "logs in an existing user using an appropriate auth hash" do
    user = User.from_omni_auth(auth_hash)
    auth_hash[:credentials][:refresh_token] = nil
    expect(user).to eq(User.from_omni_auth(auth_hash))
  end

end
