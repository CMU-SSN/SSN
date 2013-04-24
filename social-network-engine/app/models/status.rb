class Status < ActiveRecord::Base
  attr_accessible :status, :latitude, :longitude
  attr_accessor :clear
  belongs_to :user
end
