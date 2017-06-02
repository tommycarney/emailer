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
      if @user.persisted?
       sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
       set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
     else
       session["devise.google_oauth2"] = request.env["omniauth.auth"]
       redirect_to new_user_registration_url
     end
  end

end
