#--------------------------------------------------
#       osm_get_node_lats_lons_and_separate_info.pl
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


#--------------------------------------------------
#  Gets latitudes and longitudes from the XML data
#  file planet-latest.osm.bz from:
#  https://ftp.osuosl.org/pub/openstreetmap/planet
#
#  Usage:
#
#  bzcat planet-latest.osm.bz2 | perl osm_get_node_lats_lons_and_separate_info.pl |  > planet_ways_relations_only.bz2
#
#  For more information, see the documentation in
#  the Perl script that executes this script.
#
#  Reminder:  If need to verify correct file
#  content, use the Linux command "hexdump".


#--------------------------------------------------
#  Sample input line:

#  <node id="932849201" lat="210.829082" lon="-03.4156"


#--------------------------------------------------
#  Initialization.

$ascii_for_minus_sign = 45 ;
$ascii_for_decimal_point = 46 ;
$yes_yes = 1 ;
$no_no = 0 ;


#--------------------------------------------------
#  Specify Linux or Windows path style.

# $slash_or_backslash = "\\" ;  # windows
$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Clear the output log file.

$output_filename = 'output_log_from_get_lats_lons_separate.txt' ;
open( OUT_LOG, '>' , $output_filename ) or die $! ;


#-------------------------------------------------
#  Create the needed output folder, or verify it
#  already exists.
#
#  The "p" switch, for "mkdir", specifies
#  "if it does not exist".
#
#  If the output folder has any output files from
#  a previous run, delete those files.  This is
#  needed because the print statements append
#  without checking for a need to erase an
#  existing file.
#
#  Write any diagnostic info to a log file, not
#  standard output, because that is used for the
#  way and relation data.

system( 'mkdir -p ./lats_lons_in_groups >> output_log_all_processing.txt' ) ;
system( 'rm ./lats_lons_in_groups/output_packed_lats_lons_in_group_??.bin >> output_log_all_processing.txt' ) ;


#--------------------------------------------------
#  Begin a loop that reads the data.


$node_id_number_only = "" ;
$latitude_raw = "" ;
$longitude_raw = "" ;
$count_of_node_items_in_buffer_indexed_by_ending_two_digits = 0 ;
$yes_or_no_within_way_relation_data = $no_no ;
while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;


#--------------------------------------------------
#  When the way data is reached, write any data
#  that is in the output buffers, then write the
#  way and relation data to standard output where
#  it is piped to a compression utility to create
#  a separate compressed file.
#  This separate file allows the way and relation
#  info to be available without having to skip
#  over the huge amount of node data.
#
#  In the regex, \s* finds optional whitespace,
#  and \s finds required whitespace.

    if ( $yes_or_no_within_way_relation_data == $yes_yes )
    {
        print $input_line . "\n" ;
        next ;
    } elsif ( index( $input_line , "<way" ) >= 0 )
    {
        &write_packed_integers( ) ;
        print $input_line . "\n" ;
        $yes_or_no_within_way_relation_data = $yes_yes ;
        next ;
    }


#--------------------------------------------------
#  Get the node ID and its latitude and longitude
#  for every node.
#
#  Allow for the latitude and/or longitude to be
#  on a different line, and allow the end of the
#  node info to be on yet another line.
#
#  Allow for missing slash as in following data from OSM:
#  <node id="9483616092" lat="33.7108732" lon="-91.4542551" timestamp="2022-02-06T15:19:39Z" version="1" changeset="117082988" user="1T-money" uid="3715012">
#
#  Ensure the ID comes from " id=123" not from
#  " uid=123".
#
#  In the regex, \s* finds optional whitespace,
#  and \s finds required whitespace.

    if ( $input_line =~ /^\s*<node\sid="([0-9]+)"/ )
    {
        $node_id_number_only = $1 ;
        $latitude_raw = "" ;
        $longitude_raw = "" ;
    }
    if ( $node_id_number_only eq "" )
    {
        next ;
    } else
    {
        if ( $input_line =~ /lat="([\-0-9\.]+)"/ )
        {
            $latitude_raw = $1 ;
        }
        if ( $input_line =~ /lon="([\-0-9\.]+)"/ )
        {
            $longitude_raw = $1 ;
        }
        if ( ( $latitude_raw eq "" ) || ( $longitude_raw eq "" ) )
        {
            next ;
        }
    }


#--------------------------------------------------
#  Create a padded version of the node ID number.

    $count_of_leading_zeros = 12 - length( $node_id_number_only ) ;
    $node_id_padded = substr( "000000000000" , 0 , $count_of_leading_zeros ) . $node_id_number_only ;


#--------------------------------------------------
#  Get the last two digits of the node ID number as
#  an integer.
#  The ascii code for the digit zero is decimal 48.

    $length_of_node_digits = length( $node_id_number_only ) ;
    $ending_two_node_digits_as_number = ( ( ord( substr( $node_id_number_only , ( $length_of_node_digits - 2 ) , 1 ) ) - 48 ) * 10 ) + ord( substr( $node_id_number_only , ( $length_of_node_digits - 1 ) , 1 ) ) - 48 ;


#--------------------------------------------------
#  Get the current count of integers packed for the
#  current two-digit node category.

    $count_of_node_items_in_buffer_indexed_by_ending_two_digits = $count_of_buffer_positions_occupied_for_two_node_digits[ $ending_two_node_digits_as_number ] ;


#--------------------------------------------------
#  Pad the node number with leading zeros so it is
#  always 12 digits in length.
#  If the node numbers reach
#  1,000,000,000,000 then pad to 16 digits and add
#  a fourth integer in the next section.
#  Currently, in 2022, there are about
#  8,000,000,000 (active) nodes.

    $count_of_leading_zeros = 12 - $length_of_node_digits ;
    $node_number_padded = substr( "000000000000" , 0 , $count_of_leading_zeros ) . substr( $node_id_number_only , 0 , $length_of_node_digits ) ;


#--------------------------------------------------
#  Convert the latitude into a fixed-length
#  sequence of digits without any decimal point
#  and without any minus sign.
#  If the number is negative, convert the
#  numbers into the "nines complement" version.
#  If the value is positive, prepend the digit 1.
#  The result is positive-only numbers that have a
#  smooth transition from negative to positive
#  values.  The leading digit of "0" is added
#  so that the full sequence is 12 digits.

    $latitude_normalized = $latitude_raw ;
    $position_of_minus_sign = index( $latitude_normalized , '-' ) ;
    if ( $position_of_minus_sign == 0 )
    {
        $latitude_normalized = substr( $latitude_normalized , 1 ) ;
    } elsif ( $position_of_minus_sign > 0 )
    {
        $latitude_normalized = substr( $latitude_normalized , 0 , $position_of_minus_sign ) . substr( $latitude_normalized , ( $position_of_minus_sign + 1 ) ) ;
        $position_of_minus_sign = 0 ;
    }
    $position_of_decimal_point = index( $latitude_normalized , '.' ) ;
    $latitude_normalized = substr( $latitude_normalized , 0 , $position_of_decimal_point ) . substr( $latitude_normalized , ( $position_of_decimal_point + 1 ) ) ;
    $length_of_latitude = length( $latitude_normalized ) ;
    $count_of_leading_zeros = 3 - $position_of_decimal_point ;
    $count_of_trailing_zeros = $position_of_decimal_point - $length_of_latitude + 7 ;

    $latitude_normalized = substr( "000000000000" , 0 , $count_of_leading_zeros ) . $latitude_normalized . substr( "000000000000" , 0 , $count_of_trailing_zeros ) ;

    if ( $position_of_minus_sign == 0 )
    {
        $latitude_normalized =~ tr/0123456789/9876543210/ ;
        $latitude_normalized = "00" . $latitude_normalized ;
    } else
    {
        $latitude_normalized = "01" . $latitude_normalized ;
    }


#--------------------------------------------------
#  Do the same processing for the longitude.

    $longitude_normalized = $longitude_raw ;
    $position_of_minus_sign = index( $longitude_normalized , '-' ) ;
    if ( $position_of_minus_sign == 0 )
    {
        $longitude_normalized = substr( $longitude_normalized , 1 ) ;
    } elsif ( $position_of_minus_sign > 0 )
    {
        $longitude_normalized = substr( $longitude_normalized , 0 , $position_of_minus_sign ) . substr( $longitude_normalized , ( $position_of_minus_sign + 1 ) ) ;
        $position_of_minus_sign = 0 ;
    }
    $position_of_decimal_point = index( $longitude_normalized , '.' ) ;
    $longitude_normalized = substr( $longitude_normalized , 0 , $position_of_decimal_point ) . substr( $longitude_normalized , ( $position_of_decimal_point + 1 ) ) ;
    $length_of_longitude = length( $longitude_normalized ) ;
    $count_of_leading_zeros = 3 - $position_of_decimal_point ;
    $count_of_trailing_zeros = $position_of_decimal_point - $length_of_longitude + 7 ;

    $longitude_normalized = substr( "000000000000" , 0 , $count_of_leading_zeros ) . $longitude_normalized . substr( "000000000000" , 0 , $count_of_trailing_zeros ) ;

    if ( $position_of_minus_sign == 0 )
    {
        $longitude_normalized =~ tr/0123456789/9876543210/ ;
        $longitude_normalized = "00" . $longitude_normalized ;
    } else
    {
        $longitude_normalized = "01" . $longitude_normalized ;
    }


#--------------------------------------------------
#  Combine the node number, latitude, and
#  longitude into a single text string of fixed
#  length (and no spaces) and store this text in
#  an array that is indexed by the last two digits
#  of the node ID number.  The contents of the
#  array will be written later.  Also update the
#  count of integers packed, which is different
#  for each pair of ending node digits.

    $sequence_node_latitude_longitude = $node_id_padded . $latitude_normalized . $longitude_normalized ;

    $count_of_node_items_in_buffer_indexed_by_ending_two_digits ++ ;
    $node_lat_lon_for_ending_two_node_digits_at_buffer_position[ $ending_two_node_digits_as_number ][ $count_of_node_items_in_buffer_indexed_by_ending_two_digits ] = $sequence_node_latitude_longitude ;
    $count_of_buffer_positions_occupied_for_two_node_digits[ $ending_two_node_digits_as_number ] = $count_of_node_items_in_buffer_indexed_by_ending_two_digits ;

#  If needed for debugging:
#    if ( $position_of_minus_sign == 0 )
#    {
#        print OUT_LOG $input_line . "\n" . $node_id_number_only . "  " . $latitude_raw . "  " . $longitude_raw . "\n" . $sequence_node_latitude_longitude . "\n" ;
#    }


#--------------------------------------------------
#  Periodically write the packed integers to
#  output files.

    if ( $count_of_node_items_in_buffer_indexed_by_ending_two_digits > 500000 )
    {
        &write_packed_integers( ) ;
    }


#--------------------------------------------------
#  Repeat the loop for the next node.

    $node_id_number_only = "" ;
    $latitude_raw = "" ;
    $longitude_raw = "" ;
}


#--------------------------------------------------
#  Write any data that might still be in the output
#  buffers.

&write_packed_integers( ) ;


#--------------------------------------------------
#  All done.

exit( ) ;


#--------------------------------------------------
#  Subroutine that writes output files.

#  Writes the node, latitude, and longitude digits
#  in packed hexadecimal format to output files that
#  are split according to the last two digits of
#  the node ID number.
#  The packing template "h36" specifies that the
#  36 digits are encoded in hexidecimal format.
#  For this purpose only the digits 0 through 9
#  are represented, and the letters A through F are
#  not used.
#  This compression is needed because otherwise
#  the 100 files would be WAY too big for the hard
#  drive on an older laptop computer, which is
#  what is being used to develop this code.

sub write_packed_integers
{
    for ( $ending_two_node_digits_as_number = 0 ; $ending_two_node_digits_as_number <= 99 ; $ending_two_node_digits_as_number ++ )
    {
        $count_of_node_items_in_buffer_indexed_by_ending_two_digits = $count_of_buffer_positions_occupied_for_two_node_digits[ $ending_two_node_digits_as_number ] ;
        if ( $count_of_node_items_in_buffer_indexed_by_ending_two_digits > 0 )
        {
            $ending_two_node_digits_as_text = sprintf( "%02d" , $ending_two_node_digits_as_number ) ;
            $output_filename = 'lats_lons_in_groups' . $slash_or_backslash . 'output_packed_lats_lons_in_group_' . $ending_two_node_digits_as_text . '.bin' ;
            open( OUT_FILE, '>>' , $output_filename ) or die $! ;
            for ( $buffer_position = 1 ; $buffer_position <= $count_of_node_items_in_buffer_indexed_by_ending_two_digits ; $buffer_position ++ )
            {
                print OUT_FILE pack( "h36" , $node_lat_lon_for_ending_two_node_digits_at_buffer_position[ $ending_two_node_digits_as_number ][ $buffer_position ] ) ;
            }
            close( OUT_FILE ) ;
            $count_of_buffer_positions_occupied_for_two_node_digits[ $ending_two_node_digits_as_number ] = 0 ;
        }
    }
}


#--------------------------------------------------
#  End of code.

