require 'readline'
require 'date'
require 'open-uri'

DATA_START_DATE = '2008-01-01'
MAX_DAYS = 7

# Supported reading types as a hash.
# Each key is the name used by remote server to locate the data.
# Each value is a plain text label for data
READING_TYPES = {
	"Wind_Speed" => "Wind Speed",
	"Air_Temp"	 => "Air Temp",
	"Barometric_Press" => "Pressure"
}

def query_user_for_date_range

  start_date = nil
  end_date = nil

  until start_date && end_date
    puts "\nPlz enter start date"
    start_date = query_user_for_date

    puts "\nPlz enter end date"
    end_date =   query_user_for_date
    
    if !date_range_valid?(start_date, end_date)
      puts "Let's try again."
      start_date = end_date = nil
    end
  end

  return start_date, end_date
end

def query_user_for_date
  date = nil
  until date.is_a? Date
    prompt = "Please, enter a date as YYYY-MM-DD: "
    response = Readline.readline(prompt, true)

    exit if ['quit', 'x', 'q', 'exit'].include?(response)

    begin
	  date = Date.parse(response)
	rescue ArgumentError
        puts "\nInvalid date format."
	end	
	date = nil unless date_valid?(date)
  end

  return date
end

def date_valid?(date)
  valid_dates = Date.parse(DATA_START_DATE)..Date.today
  if valid_dates.cover?(date)
    return true
  else
  	puts "\nDate must be after #{DATA_START_DATE} and before today"
  	return false 
  end
end

def date_range_valid?(start_date, end_date)
  if start_date > end_date
  	puts "\nStart date must be before end date"
  	return false
  elsif start_date + MAX_DAYS < end_date
    puts "\nNo more than #{MAX_DAYS} days. Be kind to remote server"
    return false
  end
  return true
end

def get_readings_from_remote_for_dates(type, start_date, end_date)
  readings = []
  start_date.upto(end_date) do |date|
  	readings += get_readings_from_remote(type, date)
  end
  return readings
end

def get_readings_from_remote(type, date)
	raise "Invalid Reading Type" unless
	READING_TYPES.keys.include?(type)

  #read the remote file, split readings into a array
  base_url = "http://lpo.dt.navy.mil/data/DM"
  url = "#{base_url}/#{date.year}/#{date.strftime("%Y_%m_%d")}/#{type}"
  puts "Retrieving: #{url}"
  data = open(url).readlines

  #extract reading from each line
  # "2014_01_01 00:02:53  7.6/r/n" becomes 7.6
  readings = data.map do |line|
  	line_items = line.chomp.split(" ")
  	reading = line_items[2].to_f
  end
  return readings
end

def mean(array)
  total = array.inject(0) {|sum, x| sum += x}
  # use .to_f or you will get an integer result
  return total.to_f / array.length  
end

def median(array)
  array.sort!
  length = array.length
  if length % 2 == 1
  	return array[length/2]
  else
  	# even length, average the two middle numbers
  	item1 = array[length/2 - 1]
  	item2 = array[length/2]
  	return mean([item1, item2])
  end
end

def retrieve_and_calculate_results(start_date, end_date)
  results = {}
  READING_TYPES.each do |type, label|
    readings = get_readings_from_remote_for_dates(type, start_date, end_date)
    results[label] = {
  	  mean: mean(readings),
  	  median: median(readings)
  	}
  end
  return results
end

def output_results_table(results)
  puts
  puts "------------------------------------------"
  puts "|  Type       |  Mean        |  Median    "
  puts "------------------------------------------"
  results.each do |label, hash|
  	print "| " + label.ljust(10) + " | "
  	print sprintf("%.6f", hash[:mean]).rjust(10) + " | "
  	puts sprintf("%.6f", hash[:median]).rjust(10) + " |"
  end
  puts "--------------------------------------------------"
  puts
end


