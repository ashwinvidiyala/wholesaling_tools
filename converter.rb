require 'csv'
require 'pry'
require 'fileutils'
require_relative 'headers_and_positions'

filename = ARGV[0]
filename_without_extension = filename.split('.').first
output_filename = "#{filename_without_extension}_parsed.csv"

headers = HeadersAndPositions::ACCOUNT_MASTER[:headers].join(',') + "\n"
positions = HeadersAndPositions::ACCOUNT_MASTER[:positions]

# Create output file (if needed) with headers
unless File.exist?(output_filename)
  FileUtils.touch(output_filename)
  File.write(output_filename, headers, mode: 'a')
end

# Run through input file and save to output file simultaneously
CSV.foreach(filename, encoding: 'utf-8:utf-8') do |r|
  begin
    r.each do |row|
      CSV.open(output_filename, 'a') do |csv|
        data = []
        positions.each do |pos|
          data << row[pos]
        end
        csv << data
      end
    end
  rescue CSV::Parser::InvalidEncoding
    binding.pry
    row.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    retry
  end
end
