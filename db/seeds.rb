# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ucl     = League.create!(title: "UCL", url: "https://www.sports.ru/ucl/calendar/")
epl     = League.create!(title: "EPL", url: "https://www.sports.ru/epl/calendar/")
la_liga = League.create!(title: "La Liga", url: "https://www.sports.ru/la-liga/calendar/")  
League.each { |league| league.scrap_schedule! }

=begin
5.times do |c|
   country = Country.create!(title: "Country #{c+1}")

  10.times do |t|
    team = country.teams.create!(title: "Team #{t+1} of country #{c+1}")
  end
end
=end