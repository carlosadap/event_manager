# require 'csv'
# puts 'EventManager Initialized!'

## How to open a file
# contents = File.read('event_attendees.csv')
# puts contents

## How to load a file

# lines = File.readlines('event_attendees.csv')

# lines.each_with_index do |line, index|
#   next if index == 0
#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

## How to parse CSV

# contents = CSV.open(
#   'event_attendees.csv',
#   headers: true,
#   header_converters: :symbol
# )

# contents.each do |row|
#   name = row[:first_name]
#   zipcode = row[:zipcode]
#   puts "#{name} #{zipcode}"
# end

## Iteration 2: Cleaning up our Zip Codes

# contents = CSV.open(
#   'event_attendees.csv',
#   headers: true,
#   header_converters: :symbol
# )

# def clean_zipcode(zipcode)
#   # if zipcode.nil?
#   #   '00000'  
#   # elsif zipcode.length < 5
#   #   zipcode.rjust(5, '0')
#   # elsif zipcode.length > 5
#   #   zipcode[0..4]
#   # else
#   #   zipcode
#   # end
#   zipcode.to_s.rjust(5, '0')[0..4]
# end

# contents.each do |row|
#   name = row[:first_name]

#   zipcode = clean_zipcode(row[:zipcode])

#   puts "#{name} #{zipcode}"
# end

# Iteration 3: Using Google’s Civic Information

require 'csv'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
    legislators_names = legislators.map(&:name)
    legislators_names.join(', ')
  rescue
    'You can find your representatives by visiting www....'
  end

end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  puts "#{name} #{zipcode} #{legislators}"
end

