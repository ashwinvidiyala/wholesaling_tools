require 'csv'
require 'pry'
require 'fileutils'
require 'benchmark'

# csv = CSV.read('/test.txt')

data = []
filename = ARGV[0]
filename_without_extension = filename.split('.').first

headers = <<-HEADERS
  'Tax Account Number,SPTB Code,Roll Code,Legal Description 1,Legal Description 2,Legal Description 3,Legal Description 4,Acres,Appraisal District Number,Street Name(Property Location),Street Number(Property Location),Square Foot,Lot Size,Year Built,Zone,Map Number,Mapsco Number,Appraisal District Map Number,Owner Name 1,Owner Name 2,Owner Address 1,Owner Address 2,Owner City,Owner State,Owner Zip Code,Start Deferral,End Deferral,Deed Volume,Deed Page,Date of Deed,Owner Exemption Codes,Delinquency Date,Billed Tax Units,Non-Billed Tax Units,Current Year Land Value,Current Year Improvement Value,Current Year Adjusted Levy,Current Year Amount Due,Prior Year Amount Due,Account Status Codes,Overlap Account Number,Overlap Country Code,TAD Litigation Flag'
HEADERS

# Create output file if needed
unless File.exist?("#{filename_without_extension}_parsed.csv")
  FileUtils.touch("#{filename_without_extension}_parsed.csv")
end

Benchmark.bm do |benchmark|
  benchmark.report('Together') do
    1000.times do
      CSV.foreach(filename) do |r|
        r.each do |row|
          CSV.open("#{filename_without_extension}_parsed.csv", 'a') do |csv|
            csv << [row]
          end
        end
      end
    end
  end

  benchmark.report('Separately') do
    1000.times do
      CSV.foreach(filename) do |r|
        r.each do |row|
          data << row
        end
      end

      CSV.open("#{filename_without_extension}_parsed.csv", 'a') do |csv|
        data.each do |element|
          csv << [element]
        end
      end
    end
  end
end

# Run through given file and save to file
# CSV.foreach(filename) do |r|
#   r.each do |row|
#     CSV.open("#{filename_without_extension}_parsed.csv", 'a') do |csv|
#       csv << [row]
#     end
#   end
# end

# Save data to output file
# CSV.open("#{filename_without_extension}_parsed.csv", 'a') do |csv|
#   data.each do |element|
#     csv << [element]
#   end
# end

# File.write('test_parsed.csv', data, mode: 'a')
