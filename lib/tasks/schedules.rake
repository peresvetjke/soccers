desc "Scrap schedules data from source site 
and create or update matches for every existing league"
task :schedules => :environment do
  League.all.each { |league| league.scrap_schedule! }
end