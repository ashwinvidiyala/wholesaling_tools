# frozen_string_literal: true

# Creates output filename from input
class OutputFilenameGenerator
  attr_reader :input_filename

  def initialize(input_filename)
    @input_filename = input_filename

    sanitized_output_filename
  end

  def sanitized_output_filename
    "#{input_filename_without_special_characters}_parsed.csv"
  end

  private

  def input_filename_without_special_characters
    input_filename.split('/').last.split('.').first
  end
end
