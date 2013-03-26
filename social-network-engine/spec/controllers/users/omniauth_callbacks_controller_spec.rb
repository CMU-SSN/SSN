require 'spec_helper'

describe Users::OmniauthCallbacksController do
  render_views

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "cosa" do
    #@request.env["omniauth.auth"] = { :provider => "facebook", :uid => "1"}
    #post :facebook
    #response.should be_success
  end
end
