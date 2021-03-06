# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Aliases
man_u = Team.create!(title: "Манчестер Юнайтед")
man_u_alias = TeamAlias.create!(title: "Манчестер Юн.", team_id: man_u.id)

atletico = Team.create!(title: "Атлетико")
man_u_alias = TeamAlias.create!(title: "Атлетико Мадрид", team_id: atletico.id)


borussia_d = Team.create!(title: "Боруссия Д")
man_u_alias = TeamAlias.create!(title: "Боруссия Д.", team_id: borussia_d.id)

portu = Team.create!(title: "Порту")
ajax = Team.create!(title: "Аякс")
shakhtar = Team.create!(title: "Шахтер")
zaltsburg = Team.create!(title: "РБ Зальцбург")

# Create Leagues and load schedules
epl         = League.create!(title: "EPL", url: "https://www.sports.ru/epl/calendar/")
la_liga     = League.create!(title: "La Liga", url: "https://www.sports.ru/la-liga/calendar/")  
bundesliga  = League.create!(title: "Bundesliga", url: "https://www.sports.ru/bundesliga/calendar/")  
seria_a     = League.create!(title: "Seria A", url: "https://www.sports.ru/seria-a/calendar/")  
ligue_1     = League.create!(title: "Ligue 1", url: "https://www.sports.ru/ligue-1/calendar/")  
rfpl        = League.create!(title: "RFPL", url: "https://www.sports.ru/rfpl/calendar/")
ucl         = League.create!(title: "UCL", url: "https://www.sports.ru/ucl/calendar/")
liga_europa = League.create!(title: "liga-europa", url: "https://www.sports.ru/liga-europa/calendar/")
League.all.each { |league| league.scrap_schedule! }

# Collect ratings
(1..5).each do |p|
  rs = RatingsScrapper.new("https://www.transfermarkt.ru/statistik/klubrangliste?page=#{p}")
  rs.call
end

=begin
5.times do |c|
   country = Country.create!(title: "Country #{c+1}")

  10.times do |t|
    team = country.teams.create!(title: "Team #{t+1} of country #{c+1}")
  end
end
=end