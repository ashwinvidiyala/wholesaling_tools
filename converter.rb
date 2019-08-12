require 'csv'
require 'pry'
require 'fileutils'
require_relative 'headers_and_positions'
require_relative 'output_filename_generator'
require_relative 'file_converter'

# Create an OptionParser class that parses through ARGV and looks for options.
# There's very low value in supporting multiple file uploads. Just allow for one
# file upload and then the rest can be options. Also have some sort of -h help
# flag that shows usage of this. It's going to be like a quasi CLI :)
ARGV.each_with_index do |argv, i|
  puts "Converting File #{i + 1}/#{ARGV.length} '#{argv}'..."

  output_file = OutputFilenameGenerator.new(argv).sanitized_output_filename
  FileConverter.new(
    headers: HeadersAndPositions::ACCOUNT_MASTER[:headers].join(',') + "\n",
    positions: HeadersAndPositions::ACCOUNT_MASTER[:positions],
    input_file: argv,
    output_file: output_file
  ).convert

  puts "Finished converting File #{i + 1}/#{ARGV.length} and saved to '#{output_file}'"
end
