<b>BizAt</b> is open-source software that gets single-location restaurants, cafes, bakeries, bookstores, etc., and cities and intersections from the Open Street Map planet database.
====================

Software license
----------------

(c) Copyright 2023 by Richard Fobes at SolutionsCreative.com .  Permission to copy and use and modify this software is hereby given to individuals and to businesses with ten or fewer employees if this copyright notice is included in all copies and modified copies.  All other rights are reserved.  Businesses with more than ten employees are encouraged to contract with small businesses to supply the service of running this software if there are arrangements for either business to make donations to support the Open Street Map project.
Disclaimer of Warranty:  THERE IS NO WARRANTY FOR THIS SOFTWARE. THE COPYRIGHT HOLDER PROVIDES THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE FITNESS FOR A PARTICULAR PURPOSE.  Limitation of Liability:  IN NO EVENT WILL THE COPYRIGHT HOLDER BE LIABLE TO ANYONE FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE SOFTWARE.

Overview
--------

**BizAt** is a set of standalone (no-dependency) Perl scripts that get information about general-interest neighborhood businesses at every location worldwide.  The data is extracted from the Open Street Map global database file.

The extracted information includes the type of business, its name, the website for the business (if it is known), and the latitude and longitude of the business.  If the business is not a *node* (which has just one latitude and longitude), the midpoint of the business is calculated using all the nodes that are referenced in a *way* or in a combination of *ways* and a *relation*.  (A relation with at least two ways is needed for a restaurant that has a roofless center patio.)

This business info is split into two categories.  One category contains general-interest businesses such as restaurants, cafés, bakeries, bookstores, and hardware stores.  The other category contains businesses that are less often searched for, such as dentists, hair salons, auto repair shops, and antique stores.

Copies of both categories are split across multiple text files to allow fast access for any location on the planet.  This data is used by the [News Here Now web app](https://www.newsherenow.com).

This software also gets the street names and locations (latitude and longitude) of street intersections.  This intersection data allows a user's exact latitude and longitude to be partially anonymized to the nearest intersection.  This layer of anonymity protects against spyware that could calculate the user's exact location from a list of businesses that include the distance of each business from the requested center location.

The software also gets the names and midpoints (or label locations) of villages, cities, states, provinces, and other administrative boundaries.

Optionally, if the GeoNames postal code data has been downloaded, it is used to associate cities in some nations (US, CA, BR, PT, GB, SE, PL, IN, JP, and AU) with postal codes.


Latitude and longitude format
-------------

For faster processing, latitudes and longitudes are converted into, and then handled as, positive integers, without a decimal point and without any minus sign.  To convert any such integer back into a signed decimal number, if the first digit is <i>1</i> then remove the <i>1</i> and insert a decimal point to the left of the right-most eight digits, or else if the first digit is <i>0</i> then add a minus sign and convert each digit to its "nines complement" value.  The "nines complement" conversion changes each <i>9</i> to <i>0</i>, each <i>8</i> to <i>1</i>, each <i>7</i> to <i>2</i>, etc. down to each <i>2</i> to <i>7</i>, each <i>1</i> to <i>8</i>, and each <i>0</i> to <i>9</i>.  Using this convention causes the numbers to have smooth transitions at the equator (10000000000) and zero meridian (10000000000).  Specifically the next point in the negative direction is <i>09999999999</i>.  Note that these conversions are text-based so they do not involve converting to or from software-based "integers".

Usage instructions:
----------------

<b>Here's the short version</b>:  Put all the Perl scripts and the Open Street Map planet database file into the same folder on a Linux computer and run the script named <i>osm_processing_do_all.pl</i>, which will run for several days.  Optionally, after that, you can run the script named <i>osm_processing_get_intersections.pl</i> to get street intersections.

<b>Here are the detailed instructions</b>:

<b>Step 1</b>:  Choose a spare computer (which can be an old laptop or old PC) that runs the Linux operating system, and which can run 24 hours a day for more than a week.  The available disk storage capacity should be at least four times the current size of the Open Street Map "planet" database file.  The supplied software does not use unusual amounts of memory, but modifying the software can dramatically increase memory usage (and can dramatically increase disk storage requirements).  A solid state drive (SSD) instead of a hard disk drive (HDD) greatly increases the processing speed because the software reads and writes lots of big files.

<b>Step 2</b>:  Download to that computer the latest version of the Open Street Map "planet" database file, which is named <i>planet-latest.osm.bz2</i>.  (This can be done using the Firefox browser, in which case it's helpful to view the progress indicator.)  The time required for this download over a somewhat-typical internet connection can be 12 or more hours.

Important:  Please use an appropriate "mirror" source for getting this huge file.  Also be sure your use of the processed data is permitted, and that the Open Street Map Foundation is (or will be) properly attributed as the source of the data.

<b>Step 3</b>:  Move the planet database file and all the scripts in this repository into the same directory.  (Move the huge file as a single step, without requiring the operating system to first make a copy the file.)

<b>Step 4</b>: View and probably edit the file named <i>osm_processing_do_all.pl</i>.

Specifically:  This Perl script was developed one piece at a time and has not yet been executed as a single week-long process, so you MUST verify that this script is edited so that it runs the needed parts of the process and does not also run unneeded parts of the process.  As a related point, consider that the full processing gets both businesses and cities, but the city information seldom changes, so you can reduce processing time when you just want to update business information.  To make this change, "comment out" the code that only deals with getting city information.

Hint:  When choosing which lines of code to consider commenting out, focus on the lines that immediately follow a line that contains the acronym "conlts", which is an acronym for the words "Comment Out Next Line To Skip".  Most of the other lines of code run quickly and just log useful information to the log file named <i>output_log_all_processing.txt</i>.

Hint:  If you are running, or re-running, part of the code because you are testing a change in that part of the code, then you should comment out the parts already done (some of which consume days of processing time) so they do not overwrite the already-correct "output" files.  Also remember you can insert the <i>exit</i> command to stop execution just after the part you are testing.

<b>Step 5</b>: Open a command-line terminal, use the <i>cd</i> ("change directory") command to navigate to the directory that contains the files, then run the following command:

perl osm_processing_do_all.pl

Unless you have edited this Perl script to run just a part of it, this script might run 24 hours a day for a week or more!  So make sure you carefully followed the instructions in Step 4.

None of the Perl scripts require any other software.  Only the Perl interpreter is needed, and it comes pre-installed in most Linux operating systems.

<b>Step 6</b>: Periodically monitor progress to verify that the processing is getting the information you want or expect.  To do this monitoring, watch the sizes of the files being created, and perhaps sometimes copy the file <i>output_log_all_processing.txt</i> and view its contents.

Hint:  During processing, if you try to view even a small text file in the text editor, the text editor is likely to become unresponsive, sometimes for minutes.  Instead, open a separate terminal and use Linux commands such as <i>head</i> and <i>tail</i> and <i>grep</i> to view portions of the file.

Hint:  Use the Linux <i>top</i> command running in a separate terminal to monitor resource usage such as CPU time and memory usage.  This command consumes much less processing time than the GUI version.

<b>Step 7</b>:  When the processing is done the file named <i>output_city_info_ready_to_split_decimal.txt</i> contains all the city info, the file named <i>output_businesses_filtered_decimal.txt</i> contains the single-location businesses of specific types that interest most people, and the file named <i>output_businesses_filtered_promo_type_decimal.txt</i> contains single-location businesses that are likely to want to advertise alongside the businesses of greater interest.  The latitude and longitude numbers in these files use standard decimal notation.  The files with similar names but without the word <i>decimal</i> at the end specify the latitudes and longitudes as positive-only integer numbers, which are useful for faster processing in some situations.

Clarification:  The file named <i>output_businesses_filtered_decimal.txt</i> includes eating places such as restaurants, bakeries, cafes, delis, and tea shops.  It also includes independent bookstores that compete against Amazon, and many family-owned hardware stores that compete against Home Depot.  The file named <i>output_businesses_filtered_promo_type_decimal.txt</i> includes dentists, veterinarians, and other businesses that are of interest to only some people.

Hint:  Open the SVG (scalable vector graphics) files named <i>map_full_businesses.svg</i> and <i>map_full_cities.svg</i> in an SVG application such as <i>Inkscape</i> to view the locations of businesses and cities as a "heat" map.  This provides visual verification that the resulting data covers the entire planet.

Hint:  If you will be using the data for applications that require quickly finding businesses in a specific location, then look at the contents of the directory named <i>businesses_new</i>.  If you will be using the data to quickly find city names, then look at the contents of the directory named <i>cities_new</i>.

<b>Step 8</b>:  If you also want to get named street intersections, run the following command:

perl osm_processing_get_intersections.pl

Clarification:  If you <i>only</i> want to get street intersections, first run the <i>osm_processing_do_all.pl</i> script up to the point where that script has generated the data in the folder named <i>lats_lons_in_groups</i>.


History
=======

This software was written by Richard Fobes to supply information to the NewsHereNow.com web app.  This software is not part of the News Here Now system.
