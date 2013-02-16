class FacebookTabAppController < ApplicationController
  def signup
  end

  def load_account
    @user = current_user

    if @user.nil?
      redirect_to "/facebook_tab_app/signup"
    end
  end

  def create_account
    @user = current_user
    @user.update_attributes(params[:user])
    @user.save!
    redirect_to "/facebook_tab_app/done"
  end

  def done
  end
end
