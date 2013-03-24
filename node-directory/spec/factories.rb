
FactoryGirl.define do
  factory :node1, class: Node do
    name "Node #1"
    latitude 0
    longitude 0
    link "ssn1.com/signup"
    uid "n1"
    checkin DateTime.now
  end

  factory :node2, class: Node do
    name "Node #2"
    latitude 0
    longitude 0
    link "ssn2.com/signup"
    uid "n2"
    checkin DateTime.now
  end

  factory :node3, class: Node do
    name "Node #3"
    latitude 0
    longitude 0
    link "ssn3.com/signup"
    uid "n3"
    checkin DateTime.now
  end
end
