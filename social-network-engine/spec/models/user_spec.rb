require 'spec_helper'

describe User do
  describe "ImportFriends" do
    before(:each) do
      @brian = FactoryGirl.create(:brian)
      @james = FactoryGirl.create(:james)
      @jason = FactoryGirl.create(:jason)
      @victor = FactoryGirl.create(:victor)
    end

    it "should add Facebook friends with an SSN account to the user's friends" do
      @victor.ImportFriends([@brian.uid, @james.uid])
      @victor.friends.length.should equal(2)
      @victor.friends.index{|i| i[:friend_id] == @brian.id}.should_not be_nil
      @victor.friends.index{|i| i[:friend_id] == @james.id}.should_not be_nil
      @victor.friends.index{|i| i[:friend_id] == @jason.id}.should be_nil
    end

    it "should add Facebook friends with an SSN account and ignore those without an account" do
      @victor.ImportFriends([@brian.uid, @james.uid, "101", "102"])
      @victor.friends.length.should equal(2)
      @victor.friends.index{|i| i[:friend_id] == @brian.id}.should_not be_nil
      @victor.friends.index{|i| i[:friend_id] == @james.id}.should_not be_nil
      @victor.friends.index{|i| i[:friend_id] == @jason.id}.should be_nil
    end

    it "should not re-add Facebook friends that are already my friends" do
      @victor.friends << Friend.new(:friend => @brian, :user => @victor)
      @victor.ImportFriends([@brian.uid, @james.uid])
      @victor.friends.length.should equal(2)
      @victor.friends.index{|i| i[:friend_id] == @brian.id}.should_not be_nil
      @victor.friends.index{|i| i[:friend_id] == @james.id}.should_not be_nil
      @victor.friends.index{|i| i[:friend_id] == @jason.id}.should be_nil
    end
  end
end
