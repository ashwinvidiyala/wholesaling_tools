# Create converted file
class FileConverter
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
          # next if delinquency_date_is_not_valid?(row)

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
    formatted_headers = headers.join(',') + "\n"
    FileUtils.touch(output_file)
    File.write(output_file, formatted_headers, mode: 'a')
  end

  def positions_range_value_of_header(header)
    positions[headers.index(header)]
  end

  def delinquency_date_is_not_valid?(row)
    date_is_invalid?(delinquency_date(row))
  end

  def delinquency_date(row)
    dateify_date(row[positions_range_value_of_header('Delinquency Date')])
  end

  def convert_to_date_object(date_string)
    return nil unless date_string

    Date.strptime(date_string, '%m/%d/%Y')
  rescue ArgumentError => e
    return nil if e.message.include? 'invalid date'
  end

  def date_is_in_the_past?(date)
    return nil unless dateify_date(date)

    dateify_date(date) < Date.today
  end

  def date_is_too_far_in_the_future?(date)
    return nil unless dateify_date(date)

    (Date.today + 180) < dateify_date(date)
  end

  def dateify_date(date)
    if date.instance_of?(Date)
      date
    else
      convert_to_date_object(date)
    end
  end

  def date_is_invalid?(date)
    date_is_in_the_past?(date) || date_is_too_far_in_the_future?(date)
  end
end
