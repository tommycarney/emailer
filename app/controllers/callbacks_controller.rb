class CallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    auth = request.env['omniauth.auth']
    @user = User.from_omni_auth(auth)
    token = Token.from_omni_auth(auth)
      if @user.persisted?
       sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
       set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
     else
       session["devise.google_oauth2"] = request.env["omniauth.auth"]
       redirect_to new_user_registration_url, notice: "Sign in via Google failed."
     end
  end

end
