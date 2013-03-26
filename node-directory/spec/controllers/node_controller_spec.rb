require 'spec_helper'

describe NodeController do

  describe "register" do
    before(:each) do
      @attr = {
          :name => "Node",
          :latitude => 0,
          :longitude => 0,
          :hostname => "ssn.com"
      }
    end

    describe "new node" do
      it "should create a node with all attributes" do
        VCR.use_cassette 'controller/full_register_response' do
          lambda do
            get 'register', @attr
            response.should be_success

            json_response = JSON.parse(response.body)
            json_response["success"].should eq(true)
            json_response["uid"].should_not be_nil
          end.should change(Node, :count).by(1)
        end
      end

      it "need a name" do
        VCR.use_cassette 'controller/no_name_register_response' do
          get 'register', @attr.merge(:name => "")
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(false)
          json_response["errors"].length.should_not eq(0)
        end
      end

      it "need a latitude" do
        VCR.use_cassette 'controller/no_lat_register_response' do
          get 'register', @attr.merge(:latitude => nil)
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(false)
          json_response["errors"].length.should_not eq(0)
        end
      end

      it "need a longitude" do
        VCR.use_cassette 'controller/no_long_register_response' do
          get 'register', @attr.merge(:longitude => nil)
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(false)
          json_response["errors"].length.should_not eq(0)
        end
      end

      it "need a hostname" do
        VCR.use_cassette 'controller/no_hostname_register_response' do
          get 'register', @attr.merge(:hostname => "")
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(false)
          json_response["errors"].length.should_not eq(0)
        end
      end

      it "hostname must include 'signup'" do
        VCR.use_cassette 'controller/hostname_with_signup_register_response' do
          get 'register', @attr
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)
          json_response["uid"].should_not be_nil

          node = Node.find_by_uid(json_response["uid"])
          node.should_not be_nil
          node.link.should eq("ssn.com/signup")
        end
      end
    end

    describe "existing node" do
      it "must point to an existing node" do
        VCR.use_cassette 'controller/register_existing_node_response' do
          @node = FactoryGirl.create(:cmu_sv)
          get 'register', :uid => "NonExistent"
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(false)
          json_response["errors"].length.should_not eq(0)
        end
      end

      it "should update name" do
        VCR.use_cassette 'controller/register_existing_update_name_response' do
          @node = FactoryGirl.create(:cmu_sv)
          get 'register', :uid => @node.uid, :name => "New Name"
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          node.name.should eq("New Name")
        end
      end

      it "should update latitude" do
        VCR.use_cassette 'controller/register_existing_update_lat_response' do
          @node = FactoryGirl.create(:cmu_sv)
          get 'register', :uid => @node.uid, :latitude => 10
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          node.latitude.should eq(10)
        end
      end

      it "should update longitude" do
        VCR.use_cassette 'controller/register_existing_update_long_response' do
          @node = FactoryGirl.create(:cmu_sv)
          get 'register', :uid => @node.uid, :longitude => -122.0
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          node.longitude.should eq(-122.0)
        end
      end

      it "should update hostname" do
        VCR.use_cassette 'controller/register_existing_update_hostname_response' do
          @node = FactoryGirl.create(:cmu_sv)
          get 'register', :uid => @node.uid, :hostname => "ssn-new.com"
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          node.link.should eq("ssn-new.com/signup")
        end
      end

      it "should update the checkin" do
        VCR.use_cassette 'controller/register_existing_update_checkin_response' do
          @node = FactoryGirl.create(:cmu_sv)
          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          original_checkin = node.checkin

          # May the Gods forgive me for sleeping in a unit test...but rails...oh rails...sigh...
          sleep(1)

          get 'register', :uid => @node.uid
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node.reload
          node.checkin.should > original_checkin
        end
      end

      it "should not update address" do
        VCR.use_cassette 'controller/register_existing_not_update_address_response' do
          @node = FactoryGirl.create(:cmu_sv)
          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          original = node.address

          get 'register', :uid => @node.uid, :address => "New Address"
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node.reload
          node.address.should_not eq("New Address")
        end
      end

      it "should not update state" do
        VCR.use_cassette 'controller/register_existing_not_update_state_response' do
          @node = FactoryGirl.create(:cmu_sv)
          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          original = node.state

          get 'register', :uid => @node.uid, :state => "New"
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node.reload
          node.state.should eq(original)
        end
      end

      it "should not update city" do
        VCR.use_cassette 'controller/register_existing_not_update_city_response' do
          @node = FactoryGirl.create(:cmu_sv)
          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          original = node.city

          get 'register', :uid => @node.uid, :city => "New"
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node.reload
          node.city.should eq(original)
        end
      end

      it "should not update zipcode" do
        VCR.use_cassette 'controller/register_existing_not_update_zipcode_response' do
          @node = FactoryGirl.create(:cmu_sv)
          node = Node.find_by_uid(@node.uid)
          node.should_not be_nil
          original = node.zipcode

          get 'register', :uid => @node.uid, :zipcode => "New"
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)

          node.reload
          node.zipcode.should eq(original)
        end
      end
    end
  end

  describe "search" do
    before(:each) do
      VCR.use_cassette 'controller/cmu_sv_nasa_ames_sfo_response' do
        @cmu_sv = FactoryGirl.create(:cmu_sv)
        @nasa_ames = FactoryGirl.create(:nasa_ames)
        @sfo = FactoryGirl.create(:sfo)
      end
    end

    it "returns success" do
      VCR.use_cassette 'controller/search_0_response' do
      get 'search'
      response.should be_success
      end
    end

    it "should not have any results if no query was specified" do
      get 'search'
      response.should be_success
      assigns(:results).should be_nil
    end

    it "should not have any results if an empty query was specified" do
      get 'search', :q => "   "
      response.should be_success
      assigns(:results).should be_nil
    end

    it "should return results within 5 miles" do
      VCR.use_cassette 'controller/search_within_range_response' do
        get 'search', :q => "Moffett Field, CA"
        response.should be_success
        assigns(:results).length.should eq(2)
      end
    end

    it "should return results sorted by distance" do
      VCR.use_cassette 'controller/search_sorted_by_distance_response' do
        get 'search', :q => "Moffett Field, CA"
        response.should be_success
        assigns(:results).length.should eq(2)
        assigns(:results)[0].id.should eq(@cmu_sv.id)
        assigns(:results)[1].id.should eq(@nasa_ames.id)
      end
    end
  end
end
