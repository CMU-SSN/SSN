# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node do
    name "MyString"
    latitude 1.5
    longitude 1.5
    address "MyString"
    city "MyString"
    zipcode "MyString"
  end
end
