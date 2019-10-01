# frozen_string_literal: true

require_relative 'zip_code_locator'
require_relative 'output_filename_generator'

input_file = ARGV[0]
output_file = OutputFilenameGenerator.new(input_file).sanitized_output_filename

puts "Geocoding `#{input_file}`..."

ZipCodeLocator.new(
  input_file: input_file,
  output_file: output_file
).find_zip_codes

puts "Finished finding zip codes for '#{input_file}'"
