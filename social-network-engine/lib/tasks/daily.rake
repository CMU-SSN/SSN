require 'rubygems'
require 'rake'

namespace :daily do
  desc "Updates the data synchronized from Facebook"
  task :update_facebook_data => :environment do
    puts "Updating the Facebook data for all users."
    User.all().each do |user|
      puts user.name + "\n"
    end    
  end
end
