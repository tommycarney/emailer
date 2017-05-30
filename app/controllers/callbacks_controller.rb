class CallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    @user = User.from_omni_auth(request.env["omniauth.auth"])
    redirect_to root_path @user
  end

end
