class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env["omniauth.auth"]
    @user = User.where(:provider => auth.provider, :uid => auth.uid).first

    if params[:state] == "signup"
      # The user came from the signup flow
      if @user.nil?
        # User is new, continue flow
        @user = User.create(#name:auth.extra.raw_info.name,
            provider:auth.provider,
            uid:auth.uid,
            email:auth.info.email,
            password:Devise.friendly_token[0,20],
            token:auth.credentials.token,
            token_expiration:auth.credentials.expires_at)

        sign_in @user
        redirect_to "/facebook_tab_app/load_account"
      else
        # User already existed, take to done
        sign_in @user
        redirect_to "/facebook_tab_app/done"
      end
    else
      # User came from some other flow, sign him in and take him home
      if not @user.nil?
        sign_in @user
      end
      redirect_to :root
    end
  end
end
