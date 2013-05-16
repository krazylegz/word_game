FactoryGirl.define do
  factory :mad_lib do
    text { Faker::Lorem.sentence }
  end
end
