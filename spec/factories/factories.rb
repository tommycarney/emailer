require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password '123456789'
    password_confirmation '123456789'
  end

  factory :campaign do
    name "a fake name for the campaign"
    email "Hi {{name}}, what's up"
  end

  factory :contact do
    email { Faker::Internet.email }
  end

  factory :contact_attribute do
    attribute_name "name"
    attribute_value { Faker::Name.name }
  end
end
