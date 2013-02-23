class Post < ActiveRecord::Base
  attr_accessible :text, :address, :latitude, :longitude
  belongs_to :user
  validates :text, :length => {
      :minimum   => 1,
      :maximum   => 140,
      :tokenizer => lambda { |str| str.scan(/\w+/) }
  }
  geocoded_by :address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    geo = results.first
    unless geo.nil?
      obj.city = geo.city
    end
  end
  after_validation :reverse_geocode
end
