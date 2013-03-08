require 'spec_helper'

describe FacebookTabAppController do
  render_views

  describe "done" do
    describe "if not signed in" do
      it "should be not successful" do
        get :done
        response.should_not be_success
      end

      it "should not display the page if the user is not signed in" do
        get :done
        response.should_not render_template('done')
      end

      it "should redirect the user to root" do
        get :done
        response.should_not redirect_to(root_path)
      end
    end

    describe "if signed in" do
      before(:each) do
        @user = FactoryGirl.create(:victor)
        sign_in @user
      end

      it "should be successful" do
        get :done
        response.should be_success
      end

      it "should display the done page" do
        get :done
        response.should render_template('done')
      end
    end
  end
end
