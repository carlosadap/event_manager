This project is part of [The Oding Project](https://www.theodinproject.com/courses/ruby-programming/lessons/event-manager-ruby-programming)

---

# PROJECT: EVENT MANAGER

Please note this tutorial has been adapted from The Turing School’s and Jump Start Lab’s [Event Manager](http://tutorials.jumpstartlab.com/projects/eventmanager.html) and updated to use GoogleCivic API

## Learning Goals

After completing this tutorial, you will be able to:

- manipulate [file](http://rubydoc.info/stdlib/core/File) input and output
- read content from a [CSV](http://rubydoc.info/stdlib/csv/file/README.rdoc) (Comma Separated Value) file
- transform it into a standardized format
- utilize the data to contact a remote service
- populate a template with user data
- manipulate [strings](http://rubydoc.info/stdlib/core/String)
- access [Google’s Civic Information API](https://developers.google.com/civic-information/) through the [Google API Client Gem](https://github.com/google/google-api-ruby-client)
- use [ERB](http://rubydoc.info/stdlib/erb/ERB) (Embedded Ruby) for templating

This tutorial is open source. If you notice errors, typos, or have questions/suggestions, please [submit them to the project on GitHub](https://github.com/TheOdinProject/curriculum/blob/master/ruby_programming/files_and_serialization/project_event_manager.md).

## What We’re Doing in This Tutorial

Imagine that a friend of yours runs a non-profit organization around political activism. A number of people have registered for an upcoming event. She has asked for your help in engaging these future attendees. For the first task, she wants you to find the government representatives for each attendee based on their zip code.

## Initial Setup

Create a project directory folder named `event_manager` wherever you want to store your project. In the project directory, create another folder named `lib` and inside that folder create a plain text file named `event_manager.rb`. Using your command-line interface (CLI), you can enter the following commands:

```ruby
$ mkdir event_manager
$ cd event_manager
$ mkdir lib
$ touch lib/event_manager.rb
```

Creating and placing your `event_manager.rb` file in `lib` directory is entirely optional; however, it adheres to a common convention within most ruby applications. The filepaths we use in this tutorial will assume that we have put our `event_manager.rb` file within the `lib` directory.

Ruby source file names should be written all in lower-case characters and instead of camel-casing multiple words together, they are instead separated by an underscore (often called *snake_case*).

Open `lib/event_manager.rb` in your text editor and add the line:

```ruby
puts 'EventManager Initialized!'
```

Validate that ruby is installed correctly and you have created the file correctly by running it from the root of your `event_manager` directory:

```ruby
$ ruby lib/event_manager.rb
Event Manager Initialized!
```

If ruby is not installed and available on your environment path then you will be presented with the following message:

```ruby
$ ruby lib/event_manager.rb
-bash: ruby: command not found
```

If this happens, see [the instructions for installing Ruby](https://www.theodinproject.com/courses/ruby-programming/lessons/installing-ruby-ruby-programming).

If the file was not created then you will be presented with the following error message:

```
$ ruby lib/event_manager.rb
ruby: No such file or directory -- lib/event_manager.rb (LoadError)
```

If this happens, make sure the correct directory exists and try creating the file again.

For this project we are going to use the following sample data:

- [Small Sample](https://github.com/TheOdinProject/curriculum/tree/master/ruby_programming/files_and_serialization/event_attendees.csv)
- [Large Sample](https://github.com/TheOdinProject/curriculum/tree/master/ruby_programming/files_and_serialization/event_attendees_full.csv)

Download the *[small sample](https://raw.githubusercontent.com/TheOdinProject/curriculum/master/ruby_programming/files_and_serialization/event_attendees.csv)* csv file and save it in the root of the project directory, `event_manager`. Using your CLI, confirm that you are right directory and enter the following command:

```ruby
$ curl -o event_attendees.csv https://raw.githubusercontent.com/TheOdinProject/curriculum/master/ruby_programming/files_and_serialization/event_attendees.csv
```

After the file is downloaded, you should see something like:

```ruby
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2125  100  2125    0     0   3269      0 --:--:-- --:--:-- --:--:-- 12073
```

## Iteration 0: Loading a File

A comma-separated values ([CSV](http://en.wikipedia.org/wiki/Comma-separated_values)) file stores tabular data (numbers and text) in plain-text form. The CSV format is readable by a large number of applications (e.g. Excel, Numbers, Calc). Its portability makes it a popular option when sharing large sets of tabular data from a database or spreadsheet applications.

The first few rows of the CSV file you downloaded look like this:

```ruby
,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode
1,11/12/08 10:47,Allison,Nguyen,arannon@jumpstartlab.com,6154385000,3155 19th St NW,Washington,DC,20010
2,11/12/08 13:23,SArah,Hankins,pinalevitsky@jumpstartlab.com,414-520-5000,2022 15th Street NW,Washington,DC,20009
3,11/12/08 13:30,Sarah,Xx,lqrm4462@jumpstartlab.com,(941)979-2000,4175 3rd Street North,Saint Petersburg,FL,33703
4,11/25/08 19:21,David,Thomas,gdlia.lepping@jumpstartlab.com,650-799-0000,9 garrison ave,Jersey City,NJ,7306
```

### Read the File Contents

[File](http://rubydoc.info/stdlib/core/File) is a core ruby class that allows you to perform a large number of operations on files on your filesystem. The most straightforward is `File.read`.

```ruby
puts 'EventManager initialized.'

contents = File.read('event_attendees.csv')
puts contents
```

In this example, it does not matter whether you use single quotes or double quotes. There are differences, but they are essentially the same when representing a string of characters, such as this initial greeting or the name of the file.

We are assuming the file is present here. However, it is a good practice to confirm that a file exists. File has the ability to check if a file exists at the specified filepath on the filesystem through `File.exist? "event_attendees.csv"`.

### Read the File Line By Line

Reading and displaying the entire contents of the file showed us how to quickly access the data. Our goal is to display the first names of all the attendees. There are numerous [String](http://rubydoc.info/stdlib/core/String) methods that would allow us to manipulate this large string. Using `File.readlines` will save each line as a separate item in an array.

```ruby
puts 'EventManager initialized.'

lines = File.readlines('event_attendees.csv')
lines.each do |line|
  puts line
end
```

First, we read the entire contents of the file as an array of lines. Second, we iterate over the array of lines and output the contents of each line.

### Display the First Names of All Attendees

Instead of outputting the entire contents of each line we want to show only the first name. That requires us to look at the current contents of our Event Attendees file.

```ruby
 ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode
1,11/12/08 10:47,Allison,Nguyen,arannon@jumpstartlab.com,6154385000,3155 19th St NW,Washington,DC,20010
```

The first row contains header information. This row provides descriptional text for each column of data. It tells us the data columns are laid out as follows from left-to-right:

- `ID` - the empty column represents a unique identifier or row number of all the subsequent rows
- `RegDate` - the date the user registered for the event
- `first_Name` - their first name
- `last_Name` - their last name
- `Email_Address` - their email address
- `HomePhone` - their home phone number
- `Street` - their street address
- `City` - their city
- `State` - their state
- `Zipcode` - their zipcode

The lack of consistent formatting of these headers is not ideal when choosing to model your own data. These column names are our extreme example of a poorly formed external service. Great applications are often built on the backs of such services.

We are interested in the `first_Name` column. At the moment, we have a string of text that represents the entire row. We need to convert the string into an array of columns. The separation of the columns can be identified by the comma `","` separator. We want to split the string into pieces wherever we see a comma.

Ruby’s [String#split](http://rubydoc.info/stdlib/core/String#split-instance_method) allows you to convert a string of text into an array along a particular character. By default when you send the split message to the String without a parameter it will break the string apart along each space " " character. Therefore, we need to specify the comma "," character to separate the columns.

```ruby
puts 'EventManager initialized.'

lines = File.readlines('event_attendees.csv')
lines.each do |line|
  columns = line.split(",")
  p columns
end
```

Within our array of columns we want to access our ‘first_Name’. This would be the third column or third element at the array’s second index `columns[2]`. Remember, arrays start counting at 0 instead of 1, so `columns[0]` is how we would access the array’s first element, and `columns[2]` will give us the third.

```ruby
puts 'EventManager initialized.'

lines = File.readlines('event_attendees.csv')
lines.each do |line|
  columns = line.split(",")
  name = columns[2]
  puts name
end
```

### Skipping the Header Row

The header row was a great help to us in understanding the contents of the CSV file. However, the row itself does not represent an actual attendee. To ensure that we only output attendees, we could remove the header row from the file, but that would make it difficult if we later returned to the file and tried to understand the columns of data.

Another option is to ignore the first row when we display the names. Currently we handle all the rows exactly the same, which makes it difficult to understand which one is the header row.

One way to solve this problem would be to skip the line when it exactly matches our current header row.

```ruby
puts 'EventManager initialized.'

lines = File.readlines('event_attendees.csv')
lines.each do |line|
  next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
  columns = line.split(",")
  name = columns[2]
  puts name
end
```

When this program is run, the `next if` line checks every line to see if it matches the provided string. If so, it skips that line from the rest of the loop

A problem with this solution is that the content of our header row could change in the future. Additional columns could be added or the existing columns updated.

A second way to solve this problem is for us to track the index of the current line.

```ruby
puts 'EventManager initialized.'

lines = File.readlines('event_attendees.csv')
row_index = 0
lines.each do |line|
  row_index = row_index + 1
  next if row_index == 1
  columns = line.split(",")
  name = columns[2]
  puts name
end
```

This is a such a common operation that Array defines [Array#each_with_index](http://rubydoc.info/stdlib/core/Enumerable#each_with_index-instance_method).

```ruby
puts 'EventManager initialized.'

lines = File.readlines('event_attendees.csv')
lines.each_with_index do |line,index|
  next if index == 0
  columns = line.split(",")
  name = columns[2]
  puts name
end
```

This solves the problem if the header row were to change in the future. It assumes that the header row is the first row in the file.

### Look for a Solution before Building a Solution

Either of these solutions would be *OK* given our current attendees file. Problems may arise if we are given a new CSV file that is generated or manipulated by another source. This is because the CSV parser that we have started to create does not take into account a number of other features supported by the CSV file format.

Two important ones:

- CSV files often contain comments which are lines that start with a pound (#) character
- A column is unable to support a value which contains a comma (,) character

Our goal is to get in contact with our event attendees. It is not to define a CSV parser. This is often a hard concept to let go of when initially solving a problem with programming. An important rule to abide by while building software is:

Look for a Solution before Building a Solution

Ruby actually provides a CSV parser that we will use instead throughout the remainder of this exercise.

## Iteration 1: Parsing with CSV

It is likely the case that if you want to solve a problem, someone has already done it in some capacity. They may have even been kind enough to share their solution or the tools that they created. This is the kind of goodwill that pervades the Open Source community and Ruby ecosystem.

In this iteration we are going to convert our current CSV parser to use Ruby’s [CSV](http://rubydoc.info/stdlib/csv). We will then use this new parser to access our attendees’ zip codes.

### Switching over to use the CSV Library

Ruby’s core language comes with a wealth of great classes. Not all of them are loaded every single time ruby code is executed. This ensures unneeded functionality is not loaded unless required, preventing ruby from having slower start up times.

You can browse the many libraries available through the [documentation](http://rubydoc.info/stdlib).

```ruby
require 'csv'
puts 'EventManager initialized.'

contents = CSV.open('event_attendees.csv', headers: true)
contents.each do |row|
  name = row[2]
  puts name
end
```

First we need to tell Ruby that we want it to load the CSV library. This is done through the `require` method which accepts a parameter of the functionality to load.

The way [CSV](http://rubydoc.info/stdlib/csv) loads and parses data is very similar to what we previously defined.

Instead of `read` or `readlines` we use CSV’s `open` method to load our file. The library also supports the concept of headers and so we provide some additional parameters which state this file has headers.

There are pros and cons to using an external library. One of the pros is that this library makes it easy for us to express that our file has headers. One of the cons is that we have to learn how the library is implemented.

### Accessing Columns by their Names

CSV files with headers have an additional option which allows you to access the column values by their headers. Our CSV file defines several different formats for the column names. The CSV library provides an additional option which allows us to convert the header names to symbols.

Converting the headers to symbols will make our column names more uniform and easier to remember. The header “first_Name” will be converted to `:first_name` and “HomePhone” will be converted to `:homephone`.

```ruby
require 'csv'
puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true, 
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]
  puts name
end
```

### Displaying the Zip Codes of All Attendees

Accessing the zipcode is very easy using the new header name, `:zipcode`.

```ruby
require 'csv'
puts 'EventManager initialized.'

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
```

We now are able to output the name of the individual and their zipcode.

Now that we are able to visualize both pieces of data we realize that we have a problem….