# frozen_string_literal: true

# Create a converted file
class FileConverter
  SINGLE_FAMILY_HOME_SPTB_CODES = [1, 18, 23, 39].freeze # We're only targeting Single Family Homes (A, A1, A3, A4, A5) and no mobile homes (A2)
  PRIOR_YEAR_AMOUNT_DUE_MINIMUM = 1000 # This is just a random number. Over time I may increase or decrease this
  OWNER_NAMES_TO_AVOID = ['texas', 'fort worth', 'tarrant', 'fidelity'].freeze # We only want homes owned by owners
  DELINQUENCY_DATE_TO_AVOID = '01/01/9999' # These have some weird delinquency status that we don't want to fuck with
  attr_reader :headers, :positions, :input_file, :output_file

  def initialize(headers:, positions:, input_file:, output_file:)
    @headers = headers
    @positions = positions
    @input_file = input_file
    @output_file = output_file

    create_output_file_with_headers
  end

  def convert
    CSV.foreach(input_file) do |r|
      r.each do |row|
        CSV.open(output_file, 'a') do |csv|
          next if row_to_be_ignored?(row)

          data = []
          positions.each do |pos|
            data << row[pos]
          end
          data << excel_hyperlink_for(web_url_for_tarrant_county_e_statement(row))
          csv << data
        end
      end
    end
  rescue CSV::MalformedCSVError => e
    puts e.message
    puts "Deleting line number #{line_number_of_utf_encoding_error(e)}..."
    delete_foul_line_with_sed(line_number_of_utf_encoding_error(e), input_file)
    puts 'Restarting parser...'
    restart_parsing_file(input_file)
  end

  private

  def create_output_file_with_headers
    formatted_headers = headers.join(',') + "\n"
    FileUtils.touch(output_file)
    File.write(output_file, formatted_headers, mode: 'w')
  end

  def header_value_in_given_row(row, header)
    row[positions[headers.index(header)]]
  end

  def row_to_be_ignored?(row)
    sptb_code_to_be_ignored?(row) ||
      delinquency_date_to_be_avoided?(row) ||
      prior_year_amount_due_is_not_high_enough?(row) ||
      owner_name_to_be_avoided?(row)
  end

  def sptb_code_to_be_ignored?(row)
    !SINGLE_FAMILY_HOME_SPTB_CODES.include? header_value_in_given_row(row, 'SPTB Code').to_i
  end

  def prior_year_amount_due_is_not_high_enough?(row)
    header_value_in_given_row(row, 'Prior Year Amount Due').to_i < PRIOR_YEAR_AMOUNT_DUE_MINIMUM
  end

  def owner_name_to_be_avoided?(row)
    owner_name = header_value_in_given_row(row, 'Owner Name 1').downcase
    OWNER_NAMES_TO_AVOID.any? { |name| owner_name.include? name }
  end

  def delinquency_date_to_be_avoided?(row)
    DELINQUENCY_DATE_TO_AVOID == header_value_in_given_row(row, 'Delinquency Date')
  end

  def web_url_for_tarrant_county_e_statement(row)
    "https://taxonline.tarrantcounty.com/SSRSWebReport/default.aspx?id=#{header_value_in_given_row(row, 'Tax Account Number')}&type=1"
  end

  def excel_hyperlink_for(url)
    "=hyperlink(\"#{url}\")"
  end

  def line_number_of_utf_encoding_error(error)
    error.message.delete_suffix('.').split(' ').last.to_i
  end

  def delete_foul_line_with_sed(line_number, input_file)
    system("sed -i -e '#{line_number}d' #{input_file}")
  end

  def restart_parsing_file(input_file)
    system("ruby ../converter.rb #{input_file}")
  end
end
