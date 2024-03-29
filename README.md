[Tarrant County Tax Roll Converter](#tarrant-county-tax-roll-converter)\
[Tarrant County Code Violation List Enhancer](#tarrant-county-code-violation-list-enhancer)

# Tarrant County Tax Roll Converter

This is a simple Ruby program that converts the entire Tarrant County Tax Roll
from an unreadable `.dat` format to a readable `.csv` format. The Tax Roll can be
downloaded directly from the [Tarrant County
Website](http://access.tarrantcounty.com/en/tax/property-tax/tarrant-county-tax-roll.html).

**Table of Contents**

[Prepping Files](#prepping-files)\
[Running The Program](#running-the-program)\
[Joining Files](#joining-files)\
[Additional Documentation](#additional-documentation)\
[To Do](#to-do)

## Prepping Files
There's probably value in creating a copy of the file and doing this on that
instead of the original file. Just an extra layer of precaution.

Before running the gargantuan `Master.dat` file, break it up into smaller parts:

1. Copy over the `Master.dat` file to the `data` folder (which is ignored by
   git).
2. Open the file in `vim`:
   ```shell
   vim Master.dat
   ```
3. Replace commas with `/` in `vim` (commas fuck with parser):
   ```shell
   :%s/,/\//g
   ```
4. Replace double quotes with single quotes in `vim` (double quotes fuck with
   the parser):
   ```shell
   :%s/"/'/g
   ```
5. Write (save) and quit the file:
   ```shell
   :wq
   ```
6. Run the following command in the terminal:
   ```shell
   split -l 500000 Master.dat
   ```
   This will break the file into smaller files not exceeding 500,000 lines. This is required because the ruby program breaks after about 500,000 lines. *Well that's not exactly true. This might need to be edited after some testing.*

## Running the program

1. Create a folder called `data` (or whatever else you want to call it).
2. Go into the `data` folder and then run the program like this:
   ```shell
   caffeinate ruby ../converter.rb file_1 file_2 file_3 file_n
   ```
   `caffeinate` is a Mac utility that prevents the computer from sleeping while the process is running.
3. There always tends to be a problem with the second chunk `xab` (one of the smaller chunks after breaking the big file up into 500,000 line   chunks). So, it would probably be faster to run two instances of the program simultaneously. This is what I would do:
   ```shell
   caffeinate ruby ../converter.rb xaa xac xad xae # Run this in one tab
   caffeinate ruby ../converter.rb xab # Run this in another tab
   ```

### Deleting Foul Lines

**The program now automatically deletes foul lines (thank Fuck for that).**
However, if the program starts fucking up and not doing this for
whatever reason, this is how you manually delete a line using `sed`:

```shell
sed -i -e '<line-number>d' <filename>
```

If there are too many lines in a row that are messed up and it's getting tiring to
just delete one line at a time, you can also delete a range of lines (I'd start
with maybe 5 or 10 at a time):
```shell
sed -i -e '<start-line-number>,<end-line-number>d' <filename>
```

And if you want to be real slick, you can delete a line and also start running
the program again in one command. For example, let's say we want to delete line
10450 in the `xab` file:
```shell
sed -i -e '10450d' xab && caffeinate ruby ../converter.rb xab
```

## Joining Files

After the files have been converted, run this in the terminal:
```
cat file_1 file_2 file_3 file_n > joined_file.csv
```

## Additional Documentation

I have a note in Bear titled `Tarrant County Tax Roll and Tax Delinquents` that has a lot more detail about all of these things. However, this should be sufficient.

### Download The Tarrant County Tax Roll
The Tax Roll can be
downloaded directly from the [Tarrant County
Website](http://access.tarrantcounty.com/en/tax/property-tax/tarrant-county-tax-roll.html). This is the same link that's at the top of this README.

### Property Account Search
To get more information about a property, you can go to the [Property Account Search](https://taxonline.tarrantcounty.com/taxweb/accountsearch.asp) page on the Tarrant County Website. Or you can go to the [Tarrant County Homepage](http://www.tarrantcounty.com/en.html) -> `Online Services` -> `Property Account Search`.

The Account Number can be found on the csv file that's spit out by this converter.

### Tarrant County Tax Roll Definition
An incomplete version of this file can be found on the [Tarrant County Website](http://www.tarrantcounty.com/content/dam/main/tax/Tarrant%20Tax%20Roll%20Record%20Definition%20Layout.pdf).

[This is the complete Excel File](https://github.com/ashwinvidiyala/tarrant_county_tax_roll_converter/blob/master/readme_attachments/Tarrant%20County%20Tax%20Roll%20Definition/Tarrant%20Tax%20Roll%20Record%20Definition%20Layout%20(Original%20Excel%20File).xls). Or if you're interested, [Sheet 1](https://github.com/ashwinvidiyala/tarrant_county_tax_roll_converter/blob/master/readme_attachments/Tarrant%20County%20Tax%20Roll%20Definition/Tarrant%20Tax%20Roll%20Record%20Definitions%20(Sheet%201%20of%20original%20Excel%20file).pdf) and [Sheet 2](https://github.com/ashwinvidiyala/tarrant_county_tax_roll_converter/blob/master/readme_attachments/Tarrant%20County%20Tax%20Roll%20Definition/Tarrant%20Tax%20Roll%20SPTB%20Codes%20(Sheet%202%20of%20original%20Excel%20file).pdf) in PDF form (you can read PDFs directly here on GitHub).

### Tarrant County SPTB Code Definitions
I found a [Tarrant Appraisal District Property Data Layout File](http://www.tad.org/wp-contentpdf/templates/PropertyData&PropertyLocationLayouts.pdf) that has the STPB Code Definitions. If that link doesn't work (God bless the government), click on `PropertyData&PropertyLocation Layouts` on [this page](https://www.tad.org/data-download/) (under the `Property Data` tab).

The same PDF is in this repo [here](https://github.com/ashwinvidiyala/tarrant_county_tax_roll_converter/blob/master/readme_attachments/Tarrant%20Appraisal%20District%20Property%20Data%20Definition.pdf) (Appendix C).

### City of Fort Worth Tax Foreclosed Inventory FAQ
This might be a pretty useful FAQ PDF to keep handy. The original can be viewed on the [Fort Worth City Website](http://fortworthtexas.gov/propertymanagement/tax-foreclosed-FAQ.pdf).

I have also added it [here](https://github.com/ashwinvidiyala/tarrant_county_tax_roll_converter/blob/master/readme_attachments/City%20of%20Fort%20Worth%20Tax%20Foreclosed%20Property%20Inventory%20FAQ.pdf).

## To Do
- [ ] Have a linux script that replaces `"` with `'`, `,` with `/` and also
  splits the file. I'm not able to properly automate, but I sure as hell can
write some scripts to make my life easier. I can probably run this script from
the program directly too. You should probably use `sed`
  - Potentially good article: https://www.brianstorti.com/enough-sed-to-be-useful/

---

# Tarrant County Code Violation List Enhancer

This is a Ruby program that looks at the data from the Texas Appraisal District
to get owner names, mailing addresses and other information for the entries in
the Code Violations List.

**This can also be used to just fetch the Owner Name and Address from a file
with just the property addresses in Tarrant county. Just make sure the file with
the property addresses has the info in a column with the header
`Violation_Address` and that the file has the name `code` in it somewhere. I
will have to make quite a few changes to the `code_violation_enhancer` over time
to make all of this smooth, but for now, this works.**

**Table of Contents**

[Code Violation File](#code-violation-file)\
[Texas Appraisal Distrcit](#texas-appraisal-district)\
[Prepping File](#prepping-file)\
[Running The Code Violation Enhancer](#running-the-code-violation-enhancer)

## Code Violation File
1. Go to the [Fort Worth Code Violations
Page](https://data.fortworthtexas.gov/Property-Data/Code-Violations/spnu-bq4u)
and click on `Export` at the top right and then `CSV For Excel`. Look at the
screenshot if that doesn't make sense:
![](https://github.com/ashwinvidiyala/wholesaling_tools/blob/master/readme_attachments/Fort%20Worth%20Code%20Violations%20Screenshot.jpg)
2. After downloading the file, filter out only those records that have a `High Grass/Weeds` violation.
3. Filter out only the last six months' worth of data (I look at the
   `Violation_Created_Date` column). I also sort in ascending order after.
4. Copy over this information into another file (or another sheet in the same Excel
   file; you can delete the original sheet after copying over the records you
   need) and save. Select all (`cmd + a`) and copy (`cmd + c`) and then paste
   (`cmd + v`).
5. For more information about how to deal with this list: [Marketing On A
   Limited Budget by Targeting Niche Lists by Tom Krol in Wholesaling Inc
   Forum](http://myrhinotribe.com/members/index.php?threads/marketing-marketing-on-a-limited-budget-by-tom-krol-wednesday-august-7-2019.5888/#post-31912).
A [PDF of the webpage](https://github.com/ashwinvidiyala/wholesaling_tools/blob/master/readme_attachments/Marketing%20On%20A%20Limited%20Budget%20by%20Targeting%20Niche%20Lists%20by%20Tom%20Krol%20in%20Wholesaling%20Inc%20Forum.pdf) is also saved in this repo.

## Texas Appraisal District
The information for each house on the code violations list comes from the [Texas
Appraisal District Website](https://www.tad.org). The pipe delimited `.txt` file
(because apparently fucking `.csv` is too outdated for Tarrant County) is
obtained from [this page](https://www.tad.org/data-download/) on the website. We
will be using [PropertyData-Residential(Delimited)](http://www.tad.org/Data_files/Download_files/PropertyData_R(Delimited).ZIP).

[Property Data's Spec
File](https://www.tad.org/wp-contentpdf/templates/PropertyData&PropertyLocationLayouts.pdf) is also on the website.

## Prepping File
So it's the Texas Appraisal District's `PropertyData_R.txt` file that needs to
be prepped like this and NOT the `code_violation.csv` file. That took me a while
to figure out :)

1. Open the file in `vim`:
   ```shell
   vim PropertyData_R.txt
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
If you're in the `data` folder:
```shell
caffeinate ruby ../enhancer.rb PropertyData_R.txt code_violations.csv
