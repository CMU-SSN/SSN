class Post < ActiveRecord::Base
  attr_accessible :text
  belongs_to :user
  validates :text, :length => {
      :minimum   => 1,
      :maximum   => 140,
      :tokenizer => lambda { |str| str.scan(/\w+/) }
  }
end
