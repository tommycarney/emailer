require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password '123456789'
    password_confirmation '123456789'
  end

  factory :campaign do
    name "a fake name for the campaign"
    email "Hi, what's up"
  end
end
