class Node < ActiveRecord::Base
  attr_accessible :address, :city, :latitude, :longitude, :name, :zipcode
  geocoded_by :address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    geo = results.first
    unless geo.nil?
      obj.city = geo.city
      obj.zipcode = geo.postal_code
    end
  end
  after_validation :reverse_geocode
end
