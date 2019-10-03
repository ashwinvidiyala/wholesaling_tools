# frozen_string_literal: true

require_relative 'zip_code_locator'
require_relative 'output_filename_generator'

YES_VALUES = %w[y yeah yes ya yah yo 1 sure yup].freeze

input_file = ARGV[0]
output_file = OutputFilenameGenerator.new(input_file).sanitized_output_filename

puts "Do you want look up zip code from street address? (Say 'no' to use latitude and longitude)"
use_street_address = true if YES_VALUES.include?(STDIN.gets.chomp.downcase)

if use_street_address
  puts 'What is the EXACT name of the column that contains the street address?'
  street_address_column_name = STDIN.gets.chomp.downcase
end

puts "Geocoding `#{input_file}` using #{use_street_address ? 'street address' : 'latitude and longitude'}..."

ZipCodeLocator.new(
  input_file: input_file,
  output_file: output_file,
  use_street_address: use_street_address,
  street_address_column_name: street_address_column_name
).find_zip_codes

puts "Finished finding zip codes for '#{input_file}'"
