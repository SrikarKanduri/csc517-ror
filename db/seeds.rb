# require 'Faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# puts Dir.pwd
# puts IO.read("admin_secrets.txt")

# Every time you run seed, recreate every User
User.destroy_all

# Statically create Admin user if admin user doesn't exist
if !User.exists?(email: "admin@test.org")
  admin_file = IO.readlines("admin_secrets.txt")
  email = admin_file[0]
  passwd = admin_file[1]
  User.create!([email: email.to_s, password: passwd.to_s, role: "admin"])
end

# Create 5 Agents
# Name is required for an Agent
5.times do |index|
  User.create!(role: "agent",
               email: Faker::Internet.unique.email,
               password: "agent",
               first_name: Faker::Name.first_name,
               last_name: Faker::Name.last_name)
end

# Create 5 Customers
# Name is required for an Customer
5.times do |index|
  User.create!(role: "customer",
               email: Faker::Internet.unique.email,
               password: "customer",
               first_name: Faker::Name.first_name,
               last_name: Faker::Name.last_name)
end