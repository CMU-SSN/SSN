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
    end
  end

  describe "search" do
    it "returns http success" do
      get 'search'
      response.should be_success
    end
  end
end
