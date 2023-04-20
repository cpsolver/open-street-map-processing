Open-source software gets single-location restaurants, bakeries, bookstores, etc. from Open Street Map planet data
====================

Software license
----------------

(c) Copyright 2023 by Richard Fobes at SolutionsCreative.com .  Permission to copy and use and modify this software is hereby given to individuals and to businesses with ten or fewer employees if this copyright notice is included in all copies and modified copies.  All other rights are reserved.  Businesses with more than ten employees are encouraged to contract with small businesses to supply the service of running this software if they also arrange to make donations to support the Open Street Map project.
Disclaimer of Warranty:  THERE IS NO WARRANTY FOR THIS SOFTWARE. THE COPYRIGHT HOLDER PROVIDES THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE FITNESS FOR A PARTICULAR PURPOSE.  Limitation of Liability:  IN NO EVENT WILL THE COPYRIGHT HOLDER BE LIABLE TO ANYONE FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE SOFTWARE.

Latitude and longitude format
-------------

For faster processing, latitudes and longitudes are converted into, and then handled as, positive integers, without a decimal point and without any minus sign.  To convert any such integer back into a signed decimal number, if the first digit is "1" then remove the "1" and insert a decimal point to the left of the right-most eight digits, or else if the first digit is "0" then add a minus sign and convert each digit to its "nines complement" value.  The "nines complement" conversion changes each "9" to "0", each "8" to "1", each "7" to "2", etc. down to each "2" to "7", each "1" to "8", and each "0" to "9".  Using this convention causes the numbers to have smooth transitions at the equator (10000000000) and zero meridian (10000000000).  Specifically the next point in the negative direction is "09999999999".  Note that these conversions are text-based so they do not involve converting to or from software-based "integers".

Usage instructions:
----------------

Step 1:  Choose a spare computer (which can be an old laptop or old PC) that runs the Linux operating system, and which can run 24 hours a day for a week or more.  The available disk storage capacity should be at least three or four times the current size of the Open Street Map "planet" database file.  The supplied software does not use unusual amounts of memory, but modifying the software could dramatically increase memory usage.

Step 2:  Download to that computer the latest version of the Open Street Map "planet" database file, which is named "planet-latest.osm.bz2".  (This can be done using the Firefox browser, in which case it's helpful to view the progress indicator.)  The time required for this download over a somewhat-typical internet connection can be 12 or more hours.

Step 3:  Move the planet database file and all the scripts in this repository into the same directory.

Step 4: View and probably edit the file named "osm_processing_do_all.pl".

Specifically:  Verify that this script is edited so that it runs the needed parts of the process and does not also run unneeded parts of the process.  For example, the full processing gets both businesses and cities, but the city information seldom changes, so you can reduce processing time when you just want to update business information.  To make this change, "comment out" the code that only deals with getting city information.

Hint:  When choosing which lines of code to consider commenting out, focus on the lines that immediately follow a line that contains the acronym "conlts".  The acronym "conlts" is from the words "Comment Out Next Line To Skip".  Most of the other lines of code run quickly and just log useful information to the log file named "output_log_all_processing.txt".

Hint:  If you are running, or re-running, part of the code because you are testing a change in that part of the code, then you should comment out the parts already done (some of which consume days of processing time), and you can insert the "exit" command to stop execution just after the part you are testing.

Step 5: Open a command-line terminal, use the "cd" ("change directory") command to navigate to the directory that contains the files, then run the following command:

perl osm_processing_do_all.pl

Unless you have edited this Perl script to run just a part of it, this script will run 24 hours a day for a week or more!

Step 6: Periodically monitor progress to verify that the processing is getting the information you want or expect.  To do this monitoring, watch the sizes of the files being created, and perhaps sometimes copy the file "output_log_all_processing.txt" and view its contents.

Hint:  During processing, if you try to view even a small text file in the text editor, the text editor is likely to become unresponsive, sometimes for minutes.  Instead, open a separate terminal and using Linux commands such as "head" and "tail" and "grep" to view portions of the file.

Hint:  Use the Linux "top" command running in a separate terminal to monitor resource usage such as CPU time and memory usage.  This command consumes much less processing time than the GUI version.

Step 7:  When the processing is done the file named "output_city_info_ready_to_split_decimal.txt" contains all the city info, the file named "output_businesses_filtered_decimal.txt" contains the single-location businesses of specific types that interest most people, and the file named "output_businesses_filtered_promo_type_decimal.txt" contains single-location businesses that are likely to want to advertise alongside the businesses of greater interest.  The latitude and longitude numbers in these files use standard decimal notation.  The files with similar names but without the word "decimal" at the end specify the latitudes and longitudes as positive-only integer numbers, which are useful for faster processing in some situations.

Clarification:  The file named "output_businesses_filtered_decimal.txt" includes eating places such as restaurants, bakeries, cafes, delis, and tea shops.  It also includes independent bookstores that compete against Amazon, and many family-owned hardware stores that compete against Home Depot.  The file named "output_businesses_filtered_promo_type_decimal.txt" includes dentists, veterinarians, and other businesses that are of interest to only some people.

Hint:  Open the SVG (scalable vector graphics) files named "map_full_businesses.svg" and "map_full_cities.svg" in an SVG application such as "Inkscape" to view the locations of businesses and cities as a "heat" map.  This provides visual verification that the resulting data covers the entire planet.

Hint:  If you will be using the data for applications that require quickly finding businesses in a specific location, then look at the contents of the directory named "businesses_new".  If you will be using the data to quickly find city names, then look at the contents of the directory named "cities_new".

History
=======

This software was written by Richard Fobes to supply information to the NewsHereNow.com web app.
