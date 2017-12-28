require 'rails_helper'

RSpec.describe User do

  describe "attributes" do
    before do
      @user = build(:user)
    end
    it "should have an name" do
       expect(@user).to respond_to(:name)
    end
    it "should have an email" do
       expect(@user).to respond_to(:email)
    end
  end

  context "created via omniauth" do
    let :auth_hash { OmniAuth.config.mock_auth[:google_oauth2] }

    it "creates a user from an Auth Hash from Google" do
      user = User.from_omni_auth(auth_hash)
      expect(User.find_by_email("test@example.com")).to eq(user)
    end

    it " with a name" do
      user = User.from_omni_auth(auth_hash)
      expect(user.name).to eq("John Doe")
    end

    it "with an email" do
      user = User.from_omni_auth(auth_hash)
      expect(user.email).to eq("test@example.com")
    end

    it "with a provider" do
      user = User.from_omni_auth(auth_hash)
      expect(user.provider).to eq("google_oauth2")
    end
  end
end
