require 'csv'
require 'pry'
require 'fileutils'

filename = ARGV[0]
filename_without_extension = filename.split('.').first
output_filename = "#{filename_without_extension}_parsed.csv"

headers = HEADERS_AND_POSITIONS[:headers].join(',')

# Create output file if needed with headers
unless File.exist?(output_filename)
  FileUtils.touch(output_filename)
  File.write(output_filename, headers, mode: 'a')
end

# Run through given file and save to file simultaneously
CSV.foreach(filename) do |r|
  r.each do |row|
    CSV.open(output_filename, 'a') do |csv|
      csv << [row]
    end
  end
end

HEADERS_AND_POSITIONS = {
  headers: [
    'Tax Account Number',
    'SPTB Code',
    'Roll Code',
    'Legal Description 1',
    'Legal Description 2',
    'Legal Description 3',
    'Legal Description 4',
    'Acres',
    'Appraisal District Number',
    'Street Name(Property Location)',
    'Street Number(Property Location)',
    'Square Foot',
    'Lot Size',
    'Year Built',
    'Zone',
    'Map Number',
    'Mapsco Number',
    'Appraisal District Map Number',
    'Owner Name 1',
    'Owner Name 2',
    'Owner Address 1',
    'Owner Address 2',
    'Owner City',
    'Owner State',
    'Owner Zip Code',
    'Start Deferral',
    'End Deferral',
    'Deed Volume',
    'Deed Page',
    'Date of Deed',
    'Owner Exemption Codes',
    'Delinquency Date',
    'Billed Tax Units',
    'Non-Billed Tax Units',
    'Current Year Land Value',
    'Current Year Improvement Value',
    'Current Year Adjusted Levy',
    'Current Year Amount Due',
    'Prior Year Amount Due',
    'Account Status Codes',
    'Overlap Account Number',
    'Overlap Country Code',
    'TAD Litigation Flag'
  ],
  positions: [
    0..10,
    11..29,
    30..32,
    33..34,
    35..64,
    65..94,
    95..124,
    125..154,
    155..167,
    168..197,
    198..222,
    223..229,
    230..235,
    236..241,
    242..245,
    246..255,
    256..285,
    286..305,
    306..235,
    326..355,
    356..385,
    386..415,
    416..445,
    446..475,
    476..495,
    496..513,
    514..523,
    524..533,
    534..539,
    540..545,
    546..555,
    556..570,
    571..580,
    581..610,
    611..625,
    626..636,
    637..647,
    648..659,
    660..671,
    672..683,
    684..698,
    699..728,
    729..738,
    739..740
  ]
}.freeze
