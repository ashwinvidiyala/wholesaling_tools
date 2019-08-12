require 'csv'
require 'pry'
require 'fileutils'
require_relative 'headers_and_positions'
require_relative 'output_filename_generator'
require_relative 'file_converter'

ARGV.each_with_index do |argv, i|
  puts "Converting File #{i + 1}/#{ARGV.length} '#{argv}'..."

  output_file = OutputFilenameGenerator.new(argv).sanitized_output_filename
  FileConverter.new(
    headers: HeadersAndPositions::ACCOUNT_MASTER[:headers],
    positions: HeadersAndPositions::ACCOUNT_MASTER[:positions],
    input_file: argv,
    output_file: output_file
  ).convert

  puts "Finished converting File #{i + 1}/#{ARGV.length} and saved to '#{output_file}'"
end
