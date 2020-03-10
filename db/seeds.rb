# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: 'Administrator', username: 'User Admin', password: '123456', password_confirmation: '123456', admin: true)
User.create(name: Faker::FunnyName.name, username: 'non-admin', password: '654321', password_confirmation: '654321', admin: false)
# Create non-admin users

19.times do |index|
  puts index
  passwordFaker = Faker::Alphanumeric.alphanumeric(number: 10)
  User.create do | user |
    user.name = Faker::FunnyName.name
    user.username = Faker::Twitter.screen_name
    user.password = passwordFaker
    user.password_confirmation = passwordFaker
    user.admin = false
  end

  AccessReport.create do |acc_rep|
    acc_rep.entry = '2020-03-22 09:00:00'
    acc_rep.exit = rand(10) >= 5 ? "2020-03-22 17:3#{index}" : nil
    acc_rep.employee_id = index + 2
  end

end


