require 'rubygems'
require 'rake'

namespace :daily do
  desc "Updates the data synchronized from Facebook"
  task :update_facebook_data => :environment do
    puts "Updating the Facebook data for all users."
    num_success = 0
    num_failed = 0
    User.all().each do |user|
      # Don't fail if there is an error for a user's update
      begin
        user.UpdateData()
        num_success += 1
      rescue
        num_failed += 1
      end
    end    

    puts "Updated " + num_success.to_s + " users successfully"
    puts "Updates failed on " + num_failed.to_s + " users"
  end
end
