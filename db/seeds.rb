# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["Easy", "Moderate", "Strenuous"].each do |item|
  Intensity.find_or_create_by_name item
end

["Halfday","Day Trip","Overnight", "3 Days"].each do |item|
  Duration.find_or_create_by_name item
end

["Transit","Walk","Bike", "Drive", "Rideshare"].each do |item|
  TravelMode.find_or_create_by_name item
end
