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
