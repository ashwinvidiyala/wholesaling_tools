require 'csv'
require 'pry'
require 'fileutils'
require_relative 'headers_and_positions'
require_relative 'output_filename_generator'

ARGV.each do |argv|
  Converter.new(
    headers: HeadersAndPositions::ACCOUNT_MASTER[:headers].join(',') + "\n",
    positions: HeadersAndPositions::ACCOUNT_MASTER[:positions],
    input_file: argv,
    output_filename: OutputFilenameGenerator.new(filename)
  ).convert
end

# Create converted file
class Converter
  attr_reader :headers, :positions, :input_file, :output_file

  def initialize(headers:, positions:, input_file:, output_file:)
    @headers = headers
    @positions = positions
    @input_file = input_file
    @output_file = output_file

    create_output_file_with_headers
  end

  def convert
    CSV.foreach(filename) do |r|
      r.each do |row|
        CSV.open(output_file, 'a') do |csv|
          data = []
          positions.each do |pos|
            data << row[pos]
          end
          csv << data
        end
      end
    end
  end

  private

  def create_output_file_with_headers
    return if File.exist?(output_file)

    FileUtils.touch(output_file)
    File.write(output_file, headers, mode: 'a')
  end
end
