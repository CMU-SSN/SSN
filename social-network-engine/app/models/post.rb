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

  # Filters all posts to those this user is interested in. Also limits the posts
  # returned and allows the specification of an offset.
  def self.Filter(user, limit, offset)
    # Get the IDs of all organizations the user is following
    org_ids = user.organizations.map{|o| o.id}

    # Add the IDs of the cities since all cities are organizations
    org_ids += Organization::AllCities().map{|c| c.id}

    # Get the IDs of all friends
    friend_ids = user.friends.map{|f| f.id}

    Post.find(:all, :conditions => ["user_id IN (?) or organization_id IN (?)", friend_ids, org_ids], :limit => limit, :offset => offset, :order => "created_at DESC")
  end
end
