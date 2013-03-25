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

    it "returns success" do
      get 'register'
      response.should be_success
    end

    describe "new node" do
      it "should create a node with all attributes" do
        lambda do
          get 'register', @attr
          response.should be_success

          json_response = JSON.parse(response.body)
          json_response["success"].should eq(true)
          json_response["uid"].should_not be_nil
        end.should change(Node, :count).by(1)
      end

      it "need a name" do
        get 'register', @attr.merge(:name => "")
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(false)
        json_response["errors"].length.should_not eq(0)
      end

      it "need a latitude" do
        get 'register', @attr.merge(:latitude => nil)
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(false)
        json_response["errors"].length.should_not eq(0)
      end

      it "need a longitude" do
        get 'register', @attr.merge(:longitude => nil)
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(false)
        json_response["errors"].length.should_not eq(0)
      end

      it "need a hostname" do
        get 'register', @attr.merge(:hostname => "")
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(false)
        json_response["errors"].length.should_not eq(0)
      end

      it "hostname must include 'signup'" do
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

    describe "existing node" do
      before(:each) do
        @node = FactoryGirl.create(:cmu_sv)
      end

      it "must point to an existing node" do
        get 'register', :uid => "NonExistent"
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(false)
        json_response["errors"].length.should_not eq(0)
      end

      it "should update name" do
        get 'register', :uid => @node.uid, :name => "New Name"
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(true)

        node = Node.find_by_uid(@node.uid)
        node.should_not be_nil
        node.name.should eq("New Name")
      end

      it "should update latitude" do
        get 'register', :uid => @node.uid, :latitude => 10
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(true)

        node = Node.find_by_uid(@node.uid)
        node.should_not be_nil
        node.latitude.should eq(10)
      end

      it "should update longitude" do
        get 'register', :uid => @node.uid, :longitude => 10
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(true)

        node = Node.find_by_uid(@node.uid)
        node.should_not be_nil
        node.longitude.should eq(10)
      end

      it "should update hostname" do
        get 'register', :uid => @node.uid, :hostname => "ssn-new.com"
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(true)

        node = Node.find_by_uid(@node.uid)
        node.should_not be_nil
        node.link.should eq("ssn-new.com/signup")
      end

      it "should update the checkin" do
        node = Node.find_by_uid(@node.uid)
        node.should_not be_nil
        original_checkin = node.checkin

        get 'register', :uid => @node.uid
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["success"].should eq(true)

        node.reload
        node.checkin.should_not eq(original_checkin)
      end

      it "should not update address" do
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

      it "should not update state" do
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

      it "should not update city" do
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

      it "should not update zipcode" do
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

  describe "search" do
    before(:each) do
      @cmu_sv = FactoryGirl.create(:cmu_sv)
      @nasa_ames = FactoryGirl.create(:nasa_ames)
      @sfo = FactoryGirl.create(:sfo)
    end

    it "returns success" do
      get 'search'
      response.should be_success
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
      get 'search', :q => "Moffett Field, CA"
      response.should be_success
      assigns(:results).length.should eq(2)
    end

    it "should return results sorted by distance" do
      get 'search', :q => "Moffett Field, CA"
      response.should be_success
      assigns(:results).length.should eq(2)
      assigns(:results)[0].id.should eq(@cmu_sv.id)
      assigns(:results)[1].id.should eq(@nasa_ames.id)
    end
  end
end
