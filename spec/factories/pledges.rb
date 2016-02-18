FactoryGirl.define do
  factory :pledge do
    amount { 1 + rand(1000) }
  end
end
