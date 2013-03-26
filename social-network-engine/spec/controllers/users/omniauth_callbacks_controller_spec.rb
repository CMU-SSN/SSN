require 'spec_helper'

describe Users::OmniauthCallbacksController do
  render_views

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  class MockAuth < Hash
    def initialize(provider, uid, credentials)
      @provider == provider
      @uid = uid
      @credentials = credentials
    end

    def provider
      @provider
    end

    def uid
      @uid
    end

    def credentials
      @credentials
    end
  end

  class MockCredentials
    def initialize(expires, expires_at, token)
      @expires = expires
      @expires_at = expires_at
      @token = token
    end

    def expires
      @expires
    end

    def expires_at
      @expires_at
    end

    def token
      @token
    end
  end

  class MockMethod
    def get_image(arg)
      arg
    end
  end

  describe "new user" do
    before(:each) do
      Users::OmniauthCallbacksController.class_variable_set :@@util_save_picture, MockMethod.new().method(:get_image)
    end

    def set_info(mock_auth)
      mock_auth["info"] = {}
      mock_auth["info"]["name"] = "Name"
      mock_auth["info"]["image"] = "my_image"
      mock_auth["info"]["email"] = "email@test.com"
    end

    it "should create a user" do
      @mock_auth = MockAuth.new("facebook", "UserUID",
          MockCredentials.new(false, nil, "TOKEN"))
      set_info @mock_auth
      @request.env["omniauth.auth"] = @mock_auth

      lambda do
        post 'facebook', :state => "signup"

        user = User.find_by_uid("UserUID")
        user.name.should eq("Name")
        user.profile_pic.should eq("my_image")
        user.email.should eq("email@test.com")
        user.uid.should eq("UserUID")
        user.token.should eq("TOKEN")
      end.should change(User, :count).by(1)
    end

    it "without expiration date should have it set in 100 years" do
      @mock_auth = MockAuth.new("facebook", "UserUID",
          MockCredentials.new(false, nil, "TOKEN"))
      set_info @mock_auth
      @request.env["omniauth.auth"] = @mock_auth

      post 'facebook', :state => "signup"

      user = User.find_by_uid("UserUID")
      user.token.should  eq("TOKEN")
      user.token_expiration.should > Time.now().advance(:years => 99).to_datetime
    end

    it "with nul expires and an expiration date should have that reflected" do
      time_now = Time.now().advance(:months => 3)
      @mock_auth = MockAuth.new("facebook", "UserUID",
          MockCredentials.new(nil, time_now.to_i, "TOKEN"))
      set_info @mock_auth
      @request.env["omniauth.auth"] = @mock_auth

      post 'facebook', :state => "signup"

      user = User.find_by_uid("UserUID")
      user.token.should  eq("TOKEN")
      user.token_expiration.to_i.should  eq(time_now.to_i)
    end

    it "with expiration date should have that reflected" do
      time_now = Time.now().advance(:months => 3)
      @mock_auth = MockAuth.new("facebook", "UserUID",
          MockCredentials.new(true, time_now.to_i, "TOKEN"))
      set_info @mock_auth
      @request.env["omniauth.auth"] = @mock_auth

      post 'facebook', :state => "signup"

      user = User.find_by_uid("UserUID")
      user.token.should  eq("TOKEN")
      user.token_expiration.to_i.should  eq(time_now.to_i)
    end

    it "comming from the signup flow should redirect to load_account" do
      @mock_auth = MockAuth.new("facebook", "UserUID",
          MockCredentials.new(false, nil, "TOKEN"))
      set_info @mock_auth
      @request.env["omniauth.auth"] = @mock_auth

      post 'facebook', :state => "signup"
      response.should redirect_to("/facebook_tab_app/load_account")
    end

    it "not comming from the signup flow should redirect to root" do
      @mock_auth = MockAuth.new("facebook", "UserUID",
          MockCredentials.new(false, nil, "TOKEN"))
      set_info @mock_auth
      @request.env["omniauth.auth"] = @mock_auth

      post 'facebook'
      response.should redirect_to(:root)
    end
  end

  describe "existing user" do
    before(:each) do
      @user = FactoryGirl.create(:victor)
    end

    it "with an unlimited token should have it expire in 100 years" do
      @request.env["omniauth.auth"] = MockAuth.new("facebook", @user.uid,
          MockCredentials.new(false, nil, "TOKEN"))

      post 'facebook'

      @user.reload
      @user.token.should  eq("TOKEN")
      @user.token_expiration.should > Time.now().advance(:years => 99).to_datetime
    end

    it "with a limited token should have it expire when specified" do
      time_now = Time.now().advance(:months => 3)
      @request.env["omniauth.auth"] = MockAuth.new("facebook", @user.uid,
          MockCredentials.new(true, time_now.to_i, "TOKEN"))

      post 'facebook'

      @user.reload
      @user.token.should  eq("TOKEN")
      @user.token_expiration.to_i.should  eq(time_now.to_i)
    end

    it "with nil expires and a limited token should have it expire when specified" do
      time_now = Time.now().advance(:months => 3)
      @request.env["omniauth.auth"] = MockAuth.new("facebook", @user.uid,
          MockCredentials.new(nil, time_now.to_i, "TOKEN"))

      post 'facebook'

      @user.reload
      @user.token.should  eq("TOKEN")
      @user.token_expiration.to_i.should  eq(time_now.to_i)
    end

    it "comming from the signup flow should redirect to done" do
      @request.env["omniauth.auth"] = MockAuth.new("facebook", @user.uid,
          MockCredentials.new(false, nil, "TOKEN"))

      post 'facebook', :state => "signup"
      response.should redirect_to("/facebook_tab_app/done")
    end

    it "not comming from the signup flow should redirect to root" do
      @request.env["omniauth.auth"] = MockAuth.new("facebook", @user.uid,
          MockCredentials.new(false, nil, "TOKEN"))

      post 'facebook'
      response.should redirect_to(:root)
    end
  end
end
