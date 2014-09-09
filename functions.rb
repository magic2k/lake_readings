require 'readline'
require 'date'

DATA_START_DATE = '2008-01-01'
MAX_DAYS = 7

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
