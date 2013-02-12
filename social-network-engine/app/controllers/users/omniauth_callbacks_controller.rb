class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    print "\n\n\nHere at Facebook auth callback!\n\n\n"
    print request.env["omniauth.auth"]
    print "\n\n"

    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    print @user.to_s
    print "\n\n\n"
    redirect_to new_user_registration_url

#    if @user.persisted?
#      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
#      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
#    else
#      session["devise.facebook_data"] = request.env["omniauth.auth"]
#      redirect_to new_user_registration_url
#    end
  end
end
