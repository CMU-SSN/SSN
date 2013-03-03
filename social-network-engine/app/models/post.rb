class Post < ActiveRecord::Base
  attr_accessible :text, :address, :latitude, :longitude, :status
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
      obj.zipcode = geo.postal_code
    end
  end
  after_validation :reverse_geocode
  
  GOOD_STATUS = "Good"
  HELP_STATUS = "Help"
  IMMEDIATE_HELP_STATUS = "Need Immediate Help"
  ALL_STATUSES = [GOOD_STATUS, HELP_STATUS, IMMEDIATE_HELP_STATUS] 
 
  validates_inclusion_of :text, :in => ALL_STATUSES, :if => :status?
  
  def status?
    status == true
  end
end
