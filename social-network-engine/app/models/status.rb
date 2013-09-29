class Status < ActiveRecord::Base
  attr_accessible :status, :latitude, :longitude, :severity
  attr_accessor :clear, :distance, :direction

	#belongs_to :post
	#belongs_to :user  (currently linkage is user-post-status)

  before_save :set_severity
  private
  def set_severity
    if (status == Post::ALL_CLEAR_STATUS)
      self.severity = 0
    elsif (status == Post::NEEDS_ASSISTANCE_STATUS)
      self.severity = 1
    else
      self.severity = 2
    end
  end
end
