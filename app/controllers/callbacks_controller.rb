class CallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    @auth = request.env['omniauth.auth']['credentials']
    @user = User.from_omni_auth(request.env["omniauth.auth"])
    Token.create(
      access_token: @auth['token'],
      refresh_token: @auth['refresh_token'],
      expires_at: Time.at(@auth['expires_at']).to_datetime,
      email: request.env['omniauth.auth']['info']['email']
      )
    redirect_to root_path
  end

end
