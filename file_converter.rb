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
end
