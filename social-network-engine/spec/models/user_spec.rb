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
      @victor.potential_friends.should be_empty
    end

    it "should add Facebook friends without an SSN account to the user's potential friends" do
      @victor.ImportFriends(["101", "102"])
      @victor.friends.should be_empty
      @victor.potential_friends.length.should equal(2)
      @victor.potential_friends.index{|i| i[:friend_facebook_id] == "101"}.should_not be_nil
      @victor.potential_friends.index{|i| i[:friend_facebook_id] == "102"}.should_not be_nil
      @victor.potential_friends.index{|i| i[:friend_facebook_id] == "103"}.should be_nil
    end

    it "should add Facebook friends with and without an SSN account to a user" do
      @victor.ImportFriends([@brian.uid, @james.uid, "101", "102"])
      @victor.friends.length.should equal(2)
      @victor.friends.index{|i| i[:friend_id] == @brian.id}.should_not be_nil
      @victor.friends.index{|i| i[:friend_id] == @james.id}.should_not be_nil
      @victor.friends.index{|i| i[:friend_id] == @jason.id}.should be_nil
      @victor.potential_friends.length.should equal(2)
      @victor.potential_friends.index{|i| i[:friend_facebook_id] == "101"}.should_not be_nil
      @victor.potential_friends.index{|i| i[:friend_facebook_id] == "102"}.should_not be_nil
      @victor.potential_friends.index{|i| i[:friend_facebook_id] == "103"}.should be_nil
    end

    it "should add this user to other user's friends list if he was a potential friend" do
      # Brian and James have Victor as a potential friend
      @brian.potential_friends << PotentialFriend.new(:user => @brian, :friend_facebook_id => @victor.uid)
      @james.potential_friends << PotentialFriend.new(:user => @james, :friend_facebook_id => @victor.uid)

      # No one has friends before import
      @brian.friends.should be_empty
      @brian.potential_friends.should_not be_empty
      @james.friends.should be_empty
      @james.potential_friends.should_not be_empty
      @jason.friends.should be_empty
      @jason.potential_friends.should be_empty
      @victor.friends.should be_empty
      @victor.potential_friends.should be_empty

      @victor.ImportFriends([])
      @brian.reload()
      @james.reload()
      @jason.reload()
      @victor.reload()

      # Brian, James, and Victor now have a friend but no potential friends
      @brian.friends.length.should equal(1)
      @brian.potential_friends.should be_empty
      @james.friends.length.should equal(1)
      @james.potential_friends.should be_empty
      @jason.friends.should be_empty
      @jason.potential_friends.should be_empty

      # Note that Victor did not specify Brian and James as friends so they will
      # not be in his friends list
      @victor.friends.should be_empty
      @victor.potential_friends.should be_empty

      # Check that the friends are the correct ones
      @brian.friends.index{|i| i[:friend_id] == @victor.id}.should_not be_nil
      @james.friends.index{|i| i[:friend_id] == @victor.id}.should_not be_nil
      @jason.friends.index{|i| i[:friend_id] == @victor.id}.should be_nil
    end
  end
end
