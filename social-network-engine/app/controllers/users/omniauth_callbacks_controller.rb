class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env["omniauth.auth"]

    @user = User.where(:provider => auth.provider, :uid => auth.uid).first

    if @user.nil?
      # The user came from the signup flow
      if params[:state] == "signup"
        # User is new, continue flow

        # Get user profile picture
        profile_pic_name = Util::save_picture(auth['info']['image'])

        # Check if the token expires
        if not auth.credentials.expires.nil? and not auth.credentials.expires
          expiration_date = Time.now().advance(:years => 100).to_datetime
        else
          expiration_date = Time.at(auth.credentials.expires_at).to_datetime
        end

        # Create user's account
        @user = User.create(#name:auth.extra.raw_info.name,
            name:auth['info']['name'],
            profile_pic:profile_pic_name,
            provider:auth.provider,
            uid:auth.uid,
            email:auth.info.email,
            password:Devise.friendly_token[0,20],
            token:auth.credentials.token,
            token_expiration:expiration_date)

        sign_in @user
        redirect_to "/facebook_tab_app/load_account"
      else
        redirect_to :root
      end
    else
      # Sign user in and refresh Facebook token
      sign_in @user

      # Check if the token expires
      if not auth.credentials.expires.nil? and not auth.credentials.expires
        # Say it expires in 100 years
        @user.update_attributes!(
          :token => auth.credentials.token,
          :token_expiration => Time.now().advance(:years => 100).to_datetime)
      else
        @user.update_attributes!(
            :token => auth.credentials.token,
            :token_expiration => Time.at(auth.credentials.expires_at).to_datetime)
     end

      # Redirect to done if the user is in the signup flow
      if params[:state] == "signup"
        redirect_to "/facebook_tab_app/done"
      else
        redirect_to :root
      end
    end
  end
end
