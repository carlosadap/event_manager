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

# require 'csv'
# require 'google/apis/civicinfo_v2'

# def clean_zipcode(zipcode)
#   zipcode.to_s.rjust(5, '0')[0..4]
# end

# def legislators_by_zipcode(zip)
#   civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
#   civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

#   begin
#     legislators = civic_info.representative_info_by_address(
#       address: zip,
#       levels: 'country',
#       roles: ['legislatorUpperBody', 'legislatorLowerBody']
#     )
#     legislators = legislators.officials
#     legislators_names = legislators.map(&:name)
#     legislators_names.join(', ')
#   rescue
#     'You can find your representatives by visiting www....'
#   end

# end

# puts 'EventManager initialized.'

# contents = CSV.open(
#   'event_attendees.csv',
#   headers: true,
#   header_converters: :symbol
# )

# contents.each do |row|
#   name = row[:first_name]

#   zipcode = clean_zipcode(row[:zipcode])

#   legislators = legislators_by_zipcode(zipcode)

#   puts "#{name} #{zipcode} #{legislators}"
# end

# Iteration 4: Form Letters

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def clean_phone(phone)
  phone = phone.gsub(/\D/, "")
  if phone.length < 10
    "Bad number - too short"
  elsif phone.length == 10
    phone
  elsif phone.length == 11 
    if phone[0] == '1'
      phone[1..-1]
    else
      "Bad number, 11 but not 1"
    end
  else
    "Bad number - too big"
  end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find you representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exists?('output')
  
  filename = "output/thanks_#{id}.html"
  
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

reg_dates = Hash.new(0)
reg_hours = Hash.new(0)
reg_weekdays = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  phone = clean_phone(row[:homephone])
  
  date, hour = row[:regdate].split(" ")

  date = Date.strptime(date, "%m/%d/%y")
  weekday = date.strftime("%A")
  hour = DateTime.strptime(hour, "%H:%M").hour

  reg_dates[date.day] += 1
  reg_weekdays[weekday] += 1
  reg_hours[hour] += 1
  
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  # save_thank_you_letter(id, form_letter)

end

puts "Top registration day: #{reg_dates.key(reg_dates.values.max)}"
puts "Top registration weekday: #{reg_weekdays.key(reg_weekdays.values.max)}"
puts "Top registration hour: #{reg_hours.key(reg_hours.values.max)}h"


