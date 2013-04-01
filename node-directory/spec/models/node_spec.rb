require 'spec_helper'

describe Node do
  before(:each) do
    @attr = {
      :name => "Node Name",
      :latitude => 10,
      :longitude => 20,
      :link => "ssn.com/signup",
      :uid => "UID",
      :checkin => DateTime.now 
    }
  end

  it "should be successful with all the attributes" do
    VCR.use_cassette 'model/node_success_response' do
      Node.create!(@attr)
    end
  end

  it "should need a name" do
    VCR.use_cassette 'model/node_no_name_response' do
      new_node = Node.new(@attr.merge(:name => ""))
      new_node.should_not be_valid
    end
  end

  it "should need a latitude" do
    VCR.use_cassette 'model/node_no_lat_response' do
      new_node = Node.new(@attr.merge(:latitude => nil))
      new_node.should_not be_valid
    end
  end

  it "should need a longitude" do
    VCR.use_cassette 'model/node_no_long_response' do
      new_node = Node.new(@attr.merge(:longitude => nil))
      new_node.should_not be_valid
    end
  end

  it "should need a link" do
    VCR.use_cassette 'model/node_no_link_response' do
      new_node = Node.new(@attr.merge(:link => ""))
      new_node.should_not be_valid
    end
  end

  it "should need a uid" do
    VCR.use_cassette 'model/node_no_uid_response' do
      new_node = Node.new(@attr.merge(:uid => ""))
      new_node.should_not be_valid
    end
  end

  it "should need a checkin" do
    VCR.use_cassette 'model/node_no_checkin_response' do
      new_node = Node.new(@attr.merge(:checkin => nil))
      new_node.should_not be_valid
    end
  end
end
