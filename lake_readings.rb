#!/usr/bin/env ruby

require_relative('functions')

puts "\n*** LAKE PEND OREILLE READINGS ***\n"

start_date, end_date = query_user_for_date_range

# puts start_date.strftime('%B %d, %Y')
# puts   end_date.strftime('%B %d, %Y')

# READING_TYPES.each do |type, label|
#   readings = get_readings_from_remote_for_dates(type, start_date, end_date)
#   puts "#{label}: " + readings.join(", ")
# end

results = retrieve_and_calculate_results(start_date, end_date)
output_results_table(results)
