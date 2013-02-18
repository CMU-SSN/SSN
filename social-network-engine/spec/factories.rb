FactoryGirl.define do
  factory :brian, class: User do
    name "Brian Bailey"
    email "brian.bailey@sv.cmu.edu"
    uid "1"
    password "password"
  end

  factory :james, class: User do
    name "James Ricks"
    email "james.ricks@sv.cmu.edu"
    uid "2"
    password "password"
  end

  factory :jason, class: User do
    name "Jason Leng"
    email "jason.leng@sv.cmu.edu"
    uid "3"
    password "password"
  end

  factory :victor, class: User do
    name "Victor Marmol"
    email "victor.marmol@sv.cmu.edu"
    uid "4"
    password "password"
  end
end
