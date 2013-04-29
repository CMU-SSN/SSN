class Status < ActiveRecord::Base
  attr_accessible :status, :latitude, :longitude
  attr_accessor :clear
  belongs_to :user
  before_save :set_severity
  private
  def set_severity
    if (status == Post::ALL_CLEAR_STATUS)
      @severity = 0
    elsif (status == Post::NEEDS_ASSISTANCE_STATUS)
      @severity = 1
    else
      @severity = 2
    end
  end
end
