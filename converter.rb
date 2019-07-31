require 'csv'
require 'pry'
require 'fileutils'
require_relative 'headers_and_positions'

filename = ARGV[0]
filename_without_extension = filename.split('.').first
output_filename = "#{filename_without_extension}_parsed.csv"

headers = HeadersAndPositions::ACCOUNT_MASTER[:headers].join(',')

# Create output file if needed with headers
unless File.exist?(output_filename)
  FileUtils.touch(output_filename)
  File.write(output_filename, headers, mode: 'a')
end

# Run through given file and save to file simultaneously
CSV.foreach(filename) do |r|
  r.each do |row|
    CSV.open(output_filename, 'a') do |csv|
      csv << [row]
    end
  end
end
