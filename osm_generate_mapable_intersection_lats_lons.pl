#--------------------------------------------------
#       osm_generate_mapable_intersection_lats_lons.pl
#--------------------------------------------------

#  (c) Copyright 2022-2023 by Richard Fobes at SolutionsCreative.com
#  Permission to copy and use and modify this
#  software is hereby given to individuals and to
#  businesses with ten or fewer employees if this
#  copyright notice is included in all copies
#  and modified copies.
#  All other rights are reserved.
#  Businesses with more than ten employees are
#  encouraged to contract with small businesses
#  to supply the service of running this software
#  if there are arrangements for either business
#  to make donations to support the Open Street
#  Map project.
#  Disclaimer of Warranty:  THERE IS NO WARRANTY
#  FOR THIS SOFTWARE. THE COPYRIGHT HOLDER PROVIDES
#  THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY
#  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
#  BUT NOT LIMITED TO, THE FITNESS FOR A
#  PARTICULAR PURPOSE.
#  Limitation of Liability:  IN NO EVENT WILL THE
#  COPYRIGHT HOLDER BE LIABLE TO ANYONE FOR
#  DAMAGES, INCLUDING ANY GENERAL, SPECIAL,
#  INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
#  OUT OF THE USE OR INABILITY TO USE THE SOFTWARE.


#--------------------------------------------------
#  Usage:
#
#  perl osm_generate_mapable_intersection_lats_lons.pl


#--------------------------------------------------


#--------------------------------------------------
#  Sample input lines:

# 1059_1010 w4982951 w4982993 9601275 7868320
# 1059_1010 w111269061 w119374047 9435372 8502535


#--------------------------------------------------
#  Sample output lines:

#  10599601275 10107868320
#  10599435372 10108502535


#--------------------------------------------------
#  Open the output file.

$output_filename = "output_density_mapable_lats_lons.txt" ;
open( OUT_FILE , ">" , $output_filename ) ;
print "creating output file " . $output_filename . "\n" ;


#--------------------------------------------------
#  Open the input file.

$input_filename = 'output_street_intersections_after_exclusions.txt' ;
open( IN_FILE , "<" . $input_filename ) ;
print "reading input file " . $input_filename . "\n" ;


#--------------------------------------------------
#  Read the input file and write to the output
#  file.

while( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([0-9]+)_([0-9]+) [^ ]+ [^ ]+ ([0-9]+) +([0-9]+)/ )
    {
        $latitude_beginning = $1 ;
        $longitude_beginning = $2 ;
        $latitude_ending = $3 ;
        $longitude_ending = $4 ;
        print OUT_FILE $latitude_beginning . $latitude_ending . " " . $longitude_beginning . $longitude_ending . "\n" ;
    }
}


#--------------------------------------------------
#  Close the files.

close( IN_FILE ) ;
close( OUT_FILE ) ;


#--------------------------------------------------
#  All done.

