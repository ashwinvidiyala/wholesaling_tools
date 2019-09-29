# frozen_string_literal: true

require_relative 'code_violation_enhancer'
require_relative 'output_filename_generator'

ARGV.each do |argv|
  @code_violation_file = argv.downcase if argv.downcase.include?('code')
  @property_address_file = argv.downcase if argv.downcase.include?('property')
end

output_file = OutputFilenameGenerator.new(@code_violation_file).sanitized_output_filename

puts "Enhancing '#{@code_violation_file}'..."

CodeViolationEnhancer.new(
  code_violation_file: @code_violation_file,
  property_address_file: @property_address_file,
  output_file: output_file
).enhance

puts "Finished enhancing '#{@code_violation_file}' and saved to '#{output_file}'"
