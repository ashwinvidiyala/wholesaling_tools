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
    CSV.open(input_file, 'r', headers: true, header_converters: :symbol).each do |line|
      puts "Zip Code for '#{line[:violation_address]}' is #{zip_code(line)}"
      line << zip_code(line)
      write_line_to_output_file(line)
    end
  end

  private

  def create_output_file_with_headers
    headers = CSV.table(@input_file).headers.map { |header| header.to_s.capitalize }
    headers << 'Zip_Code'
    formatted_headers = headers.join(',') + "\n"
    FileUtils.touch(output_file)
    File.write(output_file, formatted_headers, mode: 'w')
  end

  def zip_code(line, use_street_address: false)
    results = if use_street_address
                Geocoder.search("#{line[:violation_address]}, Fort Worth Texas")
              else
                Geocoder.search([line[:latitude], line[:longitude]])
              end

    return unless results&.first

    results.first.data['address']['postcode'].to_i
  end

  def write_line_to_output_file(line)
    CSV.open(output_file, 'a') do |csv|
      csv << line
    end
  end
end
