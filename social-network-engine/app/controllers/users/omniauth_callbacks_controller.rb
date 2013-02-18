require 'open-uri'
require 'digest/md5'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env["omniauth.auth"]

    @user = User.where(:provider => auth.provider, :uid => auth.uid).first

    if @user.nil?
      # The user came from the signup flow
      if params[:state] == "signup"
        # User is new, continue flow

        # Get user profile picture
        profile_pics_path = "#{Rails.root}/public/profile-pics"
        FileUtils.mkdir_p(profile_pics_path) unless File.exists?(profile_pics_path)

        profile_pic_name =  "profile-pics/#{Digest::MD5.hexdigest(auth['info']['image'])}.jpg"

        open("#{Rails.root}/public/#{profile_pic_name}", 'wb') do |f|
          f << open(auth['info']['image']).read unless auth['info'].nil?
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
            token_expiration:Time.at(auth.credentials.expires_at).to_datetime)

        sign_in @user
        redirect_to "/facebook_tab_app/load_account"
      else
        redirect_to :root
      end
    else
      # Sign user in and refresh Facebook token
      sign_in @user
      @user.update_attributes!(:token => auth.credentials.token,
          :token_expiration => Time.at(auth.credentials.expires_at).to_datetime)

      # Redirect to done if the user is in the signup flow
      if params[:state] == "signup"
        redirect_to "/facebook_tab_app/done"
      else
        redirect_to :root
      end
    end
  end
end
