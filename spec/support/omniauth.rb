OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    :provider => 'google_oauth2',
    :uid => '123545',
    :credentials => {
                     :refresh_token => '12345',
                     :token         => '54321',
                     :expires_at    => 1.hour.from_now
                   },

    :info        =>  {
                     :email         => 'test@example.com',
                     :name          => 'John Doe'
    }
  })
