#!/usr/bin/env ruby

require_relative('functions')

puts "\n*** LAKE PEND OREILLE READINGS ***\n"

start_date, end_date = query_user_for_date_range

puts start_date.strftime('%B %d, %Y')
puts   end_date.strftime('%B %d, %Y')