# frozen_string_literal: true

require 'csv'
require 'pry'
require 'fileutils'
require_relative 'output_file_headers'

# Enhances Code Violation CSV
class CodeViolationEnhancer
  HEADERS = OutputFileHeaders::HEADERS.freeze

  attr_reader :actual_code_violation_file, :code_violation_file, :property_address_file, :output_file

  def initialize(code_violation_file:, property_address_file:, output_file:)
    @actual_code_violation_file = code_violation_file
    @code_violation_file = CSV.read(code_violation_file, headers: true, header_converters: :symbol, converters: :all)
    @property_address_file = property_address_file
    @output_file = output_file

    create_output_file_with_headers
  end

  def enhance
    CSV.open(property_address_file, 'r', headers: true, col_sep: '|', header_converters: :symbol).each do |property_address_file_line|
      code_violation_file.each do |code_violation_line|
        next unless code_violation_address_matches_property_data_file_address(code_violation_line, property_address_file_line)

        puts property_address_file_line[:owner_name]
        add_additional_columns(code_violation_line, property_address_file_line)

        write_data_to_output_file(code_violation_line)
      end
    end
  rescue CSV::MalformedCSVError => e
    puts e.message
    puts "Deleting line number #{line_number_of_utf_encoding_error(e)}..."
    delete_foul_line_with_sed(line_number_of_utf_encoding_error(e), property_address_file)
    puts 'Restarting parser...'
    restart_parsing_file(property_address_file, actual_code_violation_file)
  end

  private

  def code_violation_address_matches_property_data_file_address(code_violation_line, property_address_file_line)
    return false unless code_violation_line[:violation_address]

    return false unless property_address_file_line[:situs_address]

    code_violation_line[:violation_address].downcase == property_address_file_line[:situs_address].strip.downcase
  end

  def add_additional_columns(code_violation_line, property_address_file_line)
    code_violation_line << property_address_file_line[:account_num]&.strip
    code_violation_line << property_address_file_line[:owner_name]&.strip
    code_violation_line << property_address_file_line[:owner_address]&.strip
    code_violation_line << property_address_file_line[:owner_citystate]&.strip
    code_violation_line << property_address_file_line[:owner_zip]&.strip
  end

  def create_output_file_with_headers
    formatted_headers = HEADERS.join(',') + "\n"
    FileUtils.touch(output_file)
    File.write(output_file, formatted_headers, mode: 'w')
  end

  def write_data_to_output_file(code_violation_line)
    CSV.open(output_file, 'a') do |csv|
      csv << code_violation_line
    end
  end

  def line_number_of_utf_encoding_error(error)
    error.message.delete_suffix('.').split(' ').last.to_i
  end

  def delete_foul_line_with_sed(line_number, property_address_file)
    system("sed -i -e '#{line_number}d' #{property_address_file}")
  end

  def restart_parsing_file(property_address_file, actual_code_violation_file)
    system("ruby ../enhancer.rb #{property_address_file} #{actual_code_violation_file}")
  end
end
