class Node < ActiveRecord::Base
  attr_accessible :address, :city, :state, :latitude, :longitude, :name, :zipcode, :link, :uid, :checkin

  validates :name, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true
  validates :link, :presence => true
  validates :uid, :presence => true
  validates :checkin, :presence => true

  geocoded_by :address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    geo = results.first
    unless geo.nil?
      obj.city = geo.city
      obj.address = geo.address
      obj.state = geo.state_code
      obj.zipcode = geo.postal_code
    end
  end
  after_validation :reverse_geocode
end
