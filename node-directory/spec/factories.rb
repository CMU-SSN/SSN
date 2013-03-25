
FactoryGirl.define do
  factory :cmu_sv, class: Node do
    name "CMU SV"
    latitude 37.410537
    longitude -122.05988
    link "ssn1.com/signup"
    uid "n1"
    checkin DateTime.now
  end

  factory :nasa_ames, class: Node do
    name "NASA AMES"
    latitude 37.408994
    longitude -122.064471
    link "ssn2.com/signup"
    uid "n2"
    checkin DateTime.now
  end

  factory :sfo, class: Node do
    name "SFO"
    latitude 37.616502
    longitude -122.386031
    link "ssn3.com/signup"
    uid "n3"
    checkin DateTime.now
  end
end
