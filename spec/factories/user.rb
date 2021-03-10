require "faker"

FactoryBot.define do
  factory :user do |f|
    f.name {Faker::Name.name}
    f.email {Faker::Internet.email}
    f.password {"123123123"}
    f.password_confirmation {"123123123"}
  end
end
