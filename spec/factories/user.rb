FactoryBot.define do
  factory :user do 
    name { Faker::Name.name }
    username { Faker::Twitter.screen_name }
    password { '123456' }
    admin { false }
  end
end
