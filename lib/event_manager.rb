require 'csv'
puts 'EventManager Initialized!'

## How to open a file
# contents = File.read('event_attendees.csv')
# puts contents

## How to load a file
=begin 

lines = File.readlines('event_attendees.csv')
# lines.each { |line| puts line }
lines.each_with_index do |line, index|
  next if index == 0
  columns = line.split(',')
  name = columns[2]
  puts name
end

=end

## How to parse CSV

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]
  puts "#{name} #{zipcode}"
end

