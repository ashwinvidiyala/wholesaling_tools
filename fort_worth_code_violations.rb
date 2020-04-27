# frozen_string_literal: true
# This script is used in conjunction with the fort_worth_code_violations bash script

require 'dotenv/load'
require 'csv'
require 'fileutils'
require 'uri'
require 'net/http'
require 'json'
require 'date'

# Cleans up the Fort Worth Code Violations file and makes it ready to directly
# upload to Lead Sherpa for skip tracing
class FileCleaner
  HEADERS = ['Property Address', 'Property City', 'Property State', 'Property Zip', 'Custom 1', 'Custom 2']
  TARGETED_VIOLATION_TYPES = ['Health Hazard', 'High Grass/Weeds', 'Property Maintenance']

  attr_reader :input_file, :date

  def initialize(args)
    @input_file = args[0]
    @date = format_date(args[1])
  end

  def clean
    create_output_file_with_headers

    CSV.foreach(input_file, headers: true) do |row|
      CSV.open(output_file, 'a') do |csv|
        next unless TARGETED_VIOLATION_TYPES.include? row['Complaint_Type_Description']
        data = [row['Violation_Address'], row['City'], row['State'], zip_code(row), row['Case_Created_Date'], row['Complaint_Type_Description']]
        csv << data
      end
    end
  end

  private

  def create_output_file_with_headers
    formatted_headers = HEADERS.join(',') + "\n"
    FileUtils.touch(output_file)
    File.write(output_file, formatted_headers, mode: 'w')
  end

  def format_date(date)
    Date.strptime(date, '%m/%d/%Y').strftime('%B %d %Y')
  end

  def output_file
    @output_file ||= "Fort Worth Code Violations #{date}.csv"
  end

  def concatenated_address_without_zip(row)
    "#{row['Violation_Address']} #{row['City']} #{row['State']}"
  end

  def zip_code(row)
    GoogleMapsApiService.new.fetch_zip_code(concatenated_address_without_zip(row))
  end
end

# Calls the Google Maps Api
class GoogleMapsApiService
  def initialize; end

  def fetch_zip_code(incomplete_address)
    get_zip_code_from_response(make_request(google_api_url(incomplete_address)))
  end

  private

  def google_api_url(incomplete_address)
   @google_api_url ||= URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{incomplete_address}&key=#{api_key}")
  end

  def api_key
    @api_key ||= ENV['GOOGLE_API_KEY']
  end

  def make_request(url)
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)

    https.request(request)
  end

  def get_zip_code_from_response(response)
    JSON.parse(response.body).each do |key,value|
      if key == 'results'
        value.first.each do |k,v|
          if k == 'address_components'
            v.each do |response_hash|
              next unless response_hash['types'] == ['postal_code']
              return response_hash['long_name']
            end
          end
        end
      end
    end
  end
end

FileCleaner.new(ARGV).clean
