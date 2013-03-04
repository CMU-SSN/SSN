class Organization < ActiveRecord::Base
  attr_accessible :facebook_id, :name, :is_city

  has_and_belongs_to_many :users
end
