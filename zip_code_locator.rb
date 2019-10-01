# frozen_string_literal: true

require 'csv'
require 'pry'
require 'fileutils'
require 'geocoder'

# Locates Zip Code from a Latitude and Longitude
class ZipCodeLocator
  attr_reader :input_file, :output_file

  def initialize(input_file:, output_file:)
    @input_file = input_file
    @output_file = output_file

    create_output_file_with_headers
  end

  def find_zip_codes
    CSV.open(@input_file, 'r', headers: true, header_converters: :symbol).each do |line|
      puts "Zip Code for '#{line[:violation_address]}' is #{zip_code(line)}"
    end
  end

  private

  def zip_code(line)
    results = Geocoder.search([line[:latitude], line[:longitude]])

    return unless results&.first

    results.first.data['address']['postcode'].to_i
  end

  def create_output_file_with_headers
    formatted_headers = HEADERS.join(',') + "\n"
    FileUtils.touch(output_file)
    File.write(output_file, formatted_headers, mode: 'w')
  end
end
