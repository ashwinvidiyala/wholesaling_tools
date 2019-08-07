# Tarrant County Code Violation List Enhancer

This is a Ruby program that looks at the data from the Texas Appraisal District
to get owner names, mailing addresses and other information for the entries in
the Code Violations List.

## Texas Appraisal District
The information for each house on the code violations list comes from the [Texas
Appraisal District Website](https://www.tad.org). The pipe delimited `.txt` file
(because apparently fucking `.csv` is too outdated for Tarrant County) is
obtained from [this page](https://www.tad.org/data-download/) on the website. We
will be using [PropertyData-Residential(Delimited)](http://www.tad.org/Data_files/Download_files/PropertyData_R(Delimited).ZIP).

[Property Data's Spec
File](https://www.tad.org/wp-contentpdf/templates/PropertyData&PropertyLocationLayouts.pdf) is also on the website.

## Prepping File

1. Open the file in `vim`:
   ```shell
   vim code_violations.csv
   ```
2. Replace double quotes with single quotes in `vim` (double quotes fuck with
   the parser):
   ```shell
   :%s/"/'/g
   ```
3. Write (save) and quit the file:
   ```shell
   :wq
   ```

## Running The Code Violation Enhancer
```shell
ruby code_violation_enhancer.rb PropertyData_R.txt code_violations.csv
=======
# Tarrant County Tax Roll Converter

This is a simple Ruby program that converts the entire Tarrant County Tax Roll
from a unreadable `.dat` format to a readable `.csv` format. The Tax Roll can be
downloaded directly from the [Tarrant County
Website](http://www.tarrantcounty.com/content/main/en/tax/property-tax/tarrant-county-tax-roll.html?linklocation=Public%20Information%20Requests&linkname=Tax%20Roll).

## Prepping Files

Before running the gargantuan `Master.dat` file, break it up into smaller parts:

1. Copy over the `Master.dat` file to the `data` folder (which is ignored by
   git).
2. Replace commas with `/` in vim:
   ```
   :%s/,/\//g
   ```
3. Replace double quotes with single quotes in vim:
   ```
   :%s/"/'/g
   ```
4. Run the following command in the terminal:
   ```
   split -l 500000 Master.dat
   ```
   This will break the file into smaller files not exceeding 500,000 lines. This
   This is required because the ruby program breaks after about 500,000 lines.

## Running the program

Go into the `data` folder (or whichever folder the data is in), and then run the
program like this:
```
ruby ../converter.rb file_1 file_2 file_3 file_n
```

## Joining Files

Run this in the terminal:
```
cat file_1 file_2 file_3 file_n > joined_file.csv
```
