#--------------------------------------------------
#       osm_get_lat_lon_min_max.pl
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
#  if they also arrange to make donations to
#  support the Open Street Map project.
#
#  Usage:
#
#  perl osm_get_lat_lon_min_max.pl


#--------------------------------------------------
#  Input format:
#
#  The two input files must be sorted so that the
#  smallest latitude or longitude appears first
#  and the largest latitude or longitude appears
#  last, within the group of adjacent lines that
#  have the same way or relation ID number.
#  
#  w43927 08849221421
#  w574529215 10238237802
#  w574529215 10238237421
#  w574529215 10238237582
#  w86163852 08237583929
#  r4325 08849431421
#  r4325 08850479321


#--------------------------------------------------
#  Output format, where the sequence is way or
#  relation ID, latitude minimum, latitude maximum,
#  longitude minimum, longitude maximum.
#
#  w574529215 10238237802 10238237582 08773593502 08773597723


#--------------------------------------------------
#  Open the output file.

$output_filename = 'output_bounding_boxes_for_ways_and_relations.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_FILE, '>' , $output_filename ) or die $! ;


#--------------------------------------------------
#  Get the minumum and maximum latitude values for
#  each way or relation ID.

$input_filename = 'output_sorted_way_or_relation_with_latitude.txt' ;
print "input filename: " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;
%latitude_minimum_for_item_id = ( ) ;
%latitude_maximum_for_item_id = ( ) ;
while ( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([wr][0-9]+) +([0-9]{11})/ )
    {
        $item_id = $1 ;
        $latitude = $2 ;
    } else
    {
        print "unrecognized: [" . $input_line . "]" . "\n" ;
        $count_of_lines_not_recognized ++ ;
        next ;
    }
    if ( not( exists( $latitude_minimum_for_item_id{ $item_id } ) ) )
    {
        $latitude_minimum_for_item_id{ $item_id } = $latitude ;
    }
    $latitude_maximum_for_item_id{ $item_id } = $latitude ;
}
close( IN_FILE ) ;


#--------------------------------------------------
#  Do the same for the longitude values.

$input_filename = 'output_sorted_way_or_relation_with_longitude.txt' ;
print "input filename: " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;
%longitude_minimum_for_item_id = ( ) ;
%longitude_maximum_for_item_id = ( ) ;
while ( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([wr][0-9]+) +([0-9]{11})/ )
    {
        $item_id = $1 ;
        $longitude = $2 ;
    } else
    {
        print "unrecognized: [" . $input_line . "]" . "\n" ;
        $count_of_lines_not_recognized ++ ;
        next ;
    }
    if ( not( exists( $longitude_minimum_for_item_id{ $item_id } ) ) )
    {
        $longitude_minimum_for_item_id{ $item_id } = $longitude ;
    }
    $longitude_maximum_for_item_id{ $item_id } = $longitude ;
}
close( IN_FILE ) ;


#--------------------------------------------------
#  Write the results, but only if all four values
#  were found.

foreach $item_id ( keys( %latitude_minimum_for_item_id ) )
{
    if ( ( not( exists( $latitude_maximum_for_item_id{ $item_id } ) ) ) || ( not( exists( $longitude_minimum_for_item_id{ $item_id } ) ) ) || ( not( exists( $longitude_maximum_for_item_id{ $item_id } ) ) ) )
    {
        next ;
    }
    print OUT_FILE $item_id . " " . $latitude_minimum_for_item_id{ $item_id } . " " . $latitude_maximum_for_item_id{ $item_id } . " " . $longitude_minimum_for_item_id{ $item_id } . " " . $longitude_maximum_for_item_id{ $item_id } . "\n" ;

}


#--------------------------------------------------
#  Close the output file and write some log info.

close( OUT_FILE ) ;
if ( $count_of_lines_not_recognized > 0 )
{
    print "skipped " . $count_of_lines_not_recognized . " lines not recognized" . "\n" ;
}


#--------------------------------------------------
#  End of code.

