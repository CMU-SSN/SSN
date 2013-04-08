class Post < ActiveRecord::Base
  attr_accessible :text, :address, :latitude, :longitude, :status
  belongs_to :user
  belongs_to :organization
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

  ALL_CLEAR_STATUS = "STATUS_OK"
  NEEDS_ASSISTANCE_STATUS = "STATUS_NEEDS_ASSISTANCE"
  NEEDS_HELP_STATUS = "STATUS_NEEDS_HELP"
  ALL_STATUSES = [ALL_CLEAR_STATUS, NEEDS_ASSISTANCE_STATUS, NEEDS_HELP_STATUS] 
  
  POST_AS_SELF = "SELF"

  validates_inclusion_of :text, :in => ALL_STATUSES, :if => :status?

  def status?
    status == true
  end

  # Filters all posts to those this user is interested in. Also limits the posts
  # returned and allows the specification of an offset.
  def self.Filter(user, limit, last_id, location=nil, radius=nil)
    # Get the IDs of all organizations the user is following
    org_ids = user.organizations.map{|o| o.id}

    # Add the IDs of the cities since all cities are organizations
    org_ids += Organization::AllCities().map{|c| c.id}

    # Get the IDs of all friends
    friend_ids = user.friends.map{|f| f.id}

    # Include the user's own posts
    friend_ids << user.id

    # Get posts after the last ID if one was specified
    if last_id.nil? || last_id.length == 0
      conditions = ["user_id IN (?) OR organization_id IN (?)", friend_ids, org_ids]

    else
      conditions = ["id > ? AND (user_id IN (?) OR organization_id IN (?))", last_id, friend_ids, org_ids]
    end

    # Include the user information
    unless  location.is_a? Array
      location = "'#{location}'"
    end

    geoCondition = (!location.nil? && !radius.nil?) ? ".near(#{location}, #{radius.to_i}, :order=>'distance')" : ''
    eval("Post.includes([:user, :organization])#{geoCondition}.find(:all,
        :conditions => conditions,
        :limit => limit,
        :order => 'updated_at DESC')")
    #Post.includes([:user, :organization]).near("95131", 30, :order => "distance").find(:all,
    #    :conditions => conditions,
    #    :limit => limit,
    #    :order => "updated_at DESC")
  end
end
