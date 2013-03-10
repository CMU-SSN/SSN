require 'spec_helper'

describe FacebookTabAppController do
  render_views

  describe "signup" do
    describe "if not signed in" do
      it "should be successful" do
        get :signup
        response.should be_success
      end

      it "should display the signup page" do
        get :signup
        response.should render_template('signup')
      end
    end

    describe "if signed in" do
      before(:each) do
        @user = FactoryGirl.create(:victor)
        sign_in @user
      end

      it "should be successful" do
        get :signup
        response.should be_success
      end

      it "should display the signup page" do
        get :signup
        response.should render_template('signup')
      end
    end
  end

  describe "load_organizations" do
    before(:each) do
      @user = FactoryGirl.create(:victor)
      @org1 = FactoryGirl.create(:org1)
      @org2 = FactoryGirl.create(:org2)
      @city1 = FactoryGirl.create(:city1)
      @city2 = FactoryGirl.create(:city2)

      @org1.save!
      @org2.save!
      @city1.save!
      @city2.save!

      @org1.managers << @user
      @org2.managers << @user
      @city1.managers << @user
      @city2.managers << @user
    end

    it "should be successful" do
      get :load_organizations
      response.should be_success
    end

    it "should display the load organizations page" do
      get :load_organizations
      response.should render_template('load_organizations')
    end

    it "should render the done page" do
      post :load_organizations, :orgs_num => 0
      response.should render_template('done')
    end

    it "should delete organization with value == 0" do
      org1_id = "org_" + @org1.id.to_s
      org2_id = "org_" + @org2.id.to_s
      lambda do
        post :load_organizations, :orgs_num => 2, org1_id => 0, org2_id => 0
        response.should render_template('done')
      end.should change(Organization, :count).by(-2)
    end

    it "should delete cities with value == 0" do
      org1_id = "org_" + @city1.id.to_s
      org2_id = "org_" + @city2.id.to_s
      lambda do
        post :load_organizations, :orgs_num => 2, org1_id => 0, org2_id => 0
        response.should render_template('done')
      end.should change(Organization, :count).by(-2)
    end

    it "should not delete organization with value == 1" do
      org1_id = "org_" + @org1.id.to_s
      org2_id = "org_" + @org2.id.to_s
      lambda do
        post :load_organizations, :orgs_num => 2, org1_id => 1, org2_id => 1
        response.should render_template('done')
      end.should_not change(Organization, :count)
    end

    it "should not delete cities with value == 1" do
      org1_id = "org_" + @city1.id.to_s
      org2_id = "org_" + @city2.id.to_s
      lambda do
        post :load_organizations, :orgs_num => 2, org1_id => 1, org2_id => 1
        response.should render_template('done')
      end.should_not change(Organization, :count)
    end

    it "should not delete organizations with more than 1 manager even if value == 0" do
      @user2 = FactoryGirl.create(:brian)
      @org1.managers << @user2
      @org2.managers << @user2
      org1_id = "org_" + @org1.id.to_s
      org2_id = "org_" + @org2.id.to_s
      lambda do
        post :load_organizations, :orgs_num => 2, org1_id => 0, org2_id => 0
        response.should render_template('done')
      end.should_not change(Organization, :count)
    end

    it "should not delete cities with more than 1 manager even if value == 0" do
      @user2 = FactoryGirl.create(:brian)
      @city1.managers << @user2
      @city2.managers << @user2
      org1_id = "org_" + @city1.id.to_s
      org2_id = "org_" + @city2.id.to_s
      lambda do
        post :load_organizations, :orgs_num => 2, org1_id => 0, org2_id => 0
        response.should render_template('done')
      end.should_not change(Organization, :count)
    end

    it "should only delete organizations/cities with value == 0 and leave those with value == 1" do
      org1_id = "org_" + @org1.id.to_s
      org2_id = "org_" + @org2.id.to_s
      org3_id = "org_" + @city1.id.to_s
      org4_id = "org_" + @city2.id.to_s
      lambda do
        post :load_organizations, :orgs_num => 2, org1_id => 0, org2_id => 1, org3_id => 0, org4_id => 1
        response.should render_template('done')
      end.should change(Organization, :count).by(-2)
      Organization.find_by_id(@org1.id).should be_nil
      Organization.find_by_id(@org2.id).should_not be_nil
      Organization.find_by_id(@city1.id).should be_nil
      Organization.find_by_id(@city2.id).should_not be_nil
    end
  end

  describe "done" do
    describe "if not signed in" do
      it "should not be successful" do
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
