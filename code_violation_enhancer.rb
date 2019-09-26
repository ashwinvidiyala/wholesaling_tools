# frozen_string_literal: true

require 'csv'
require 'pry'
require 'fileutils'

# Enhances Code Violation CSV
class CodeViolationEnhancer
  code_violation_file = CSV.read(ARGV[1], headers: true, header_converters: :symbol, converters: :all)
  CSV.open(ARGV[0], 'r', headers: true, col_sep: '|', header_converters: :symbol).each do |property_address_line|
    code_violation_file.each do |code_violation_line|
      binding.pry
      if code_violation_line[:violation_address].downcase == property_address_line[:owner_address].strip.downcase
        puts property_address_line[:owner_name]
        code_violation_line << property_address_line[:account_num]
        # Add the other values you need, like owner address, owner name and
        # other things. 
        CSV.open('output_file', 'a') do |csv|
          # create the output file outside of this loop (like
          # /Users/ashwin/code/tarrant_county_tax_roll_converter/file_converter.rb:45)
          csv << code_violation_line
        end
      end
    end
  end
  # puts line[:Owner_Name]
  #   if csv[:violation_address] == line[70..100].strip
  #     puts csv[:violation_address]
  #   end
end

# CSV.foreach(ARGV[0]) do |csv|
#   puts csv[0]
# end
# Useful article: http://www.truetech.be/en/rubyshorts-csv-manipulation-ruby
# violation_address = []
# file.each_with_index do |row, i|
#   violation_address << row[:violation_address]
# end
# p file[0]
