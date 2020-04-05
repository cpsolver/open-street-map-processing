#--------------------------------------------------
#       osm_get_lats_lons_from_raw_data_for_listed_nodes.pl
#--------------------------------------------------

#  (c) Copyright 2014-2016 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_lats_lons_from_raw_data_for_listed_nodes.pl

#  Do not specify output log file so that progress is
#  monitored in the terminal window.

#  Can pipe output of uncompress utility into input here.


#---------------------------------------------------
#  Get the list of node IDs of interest.

$file_name_list_of_node_ids = "output_businesses_links.txt" ;
open( INFILE , "<" . $file_name_list_of_node_ids ) ;
$count_of_nodes_needed = 0 ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /(n[0-9]+)/ )
    {
        $node_id = $1 ;
        $need_node_id{ $node_id } = "y" ;
        $count_of_nodes_needed ++ ;
    }
}
close( INFILE ) ;
print "will search for " . $count_of_nodes_needed . " node IDs" . "\n" ;


#--------------------------------------------------
#  Open the OUTPUT file.

$path_and_filename_for_output = "output_lats_lons_for_listed_nodes.txt" ;
open OUTFILE , ">" . $path_and_filename_for_output ;


#--------------------------------------------------
#  Initialization for subroutine.

$zero_digits_of_count[ 0 ] = "" ;
$zero_digits_of_count[ 1 ] = "0" ;
$zero_digits_of_count[ 2 ] = "00" ;
$zero_digits_of_count[ 3 ] = "000" ;
$zero_digits_of_count[ 4 ] = "0000" ;
$zero_digits_of_count[ 5 ] = "00000" ;
$zero_digits_of_count[ 6 ] = "000000" ;
$zero_digits_of_count[ 7 ] = "0000000" ;
$zero_digits_of_count[ 8 ] = "00000000" ;
$zero_digits_of_count[ 9 ] = "000000000" ;
$zero_digits_of_count[ 10 ] = "0000000000" ;
$zero_digits_of_count[ 11 ] = "00000000000" ;
$nine_digits_of_count[ 0 ] = "" ;
$nine_digits_of_count[ 1 ] = "9" ;
$nine_digits_of_count[ 2 ] = "99" ;
$nine_digits_of_count[ 3 ] = "999" ;
$nine_digits_of_count[ 4 ] = "9999" ;
$nine_digits_of_count[ 5 ] = "99999" ;
$nine_digits_of_count[ 6 ] = "999999" ;
$nine_digits_of_count[ 7 ] = "9999999" ;
$nine_digits_of_count[ 8 ] = "99999999" ;
$nine_digits_of_count[ 9 ] = "999999999" ;
$nine_digits_of_count[ 10 ] = "9999999999" ;
$nine_digits_of_count[ 11 ] = "99999999999" ;


#--------------------------------------------------
#  Read each line in the raw data file.
#
#  Use STDIN to allow pipe from output of
#  uncompress program.

$count_of_nodes_found = 0 ;
while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;

#    $input_line =~ s/[ \n\r\t]+/ /sg ;


#--------------------------------------------------
#  Get the latitude and longitude data for the
#  nodes of interest.

    if ( $input_line =~ /^ *<node id="([0-9]+)".* lat="([\-0-9\.]+)".* lon="([\-0-9\.]+)"/ )
    {
        $node_id_number_only = $1 ;
        $latitude = $2 ;
        $longitude = $3 ;
        $node_id = "n" . $node_id_number_only ;
        if ( exists( $need_node_id{ $node_id } ) )
        {
            &convert_into_loc_format( ) ;
            print OUTFILE $node_id . " " . $location_loc . "\n" ;
            $count_of_nodes_found ++ ;
        }
    }


#--------------------------------------------------
#  Exit when the way IDs are reached.

    if ( $input_line =~ /^ *<way/ )
    {
        print "done; reached end of nodes" . "\n" ;
        exit ;
    }


#--------------------------------------------------
#  Show progress.

    if ( $interval_counter > 1000000 )
    {
        $percent_complete_tenths = sprintf( "%d" , int( 1000 * ( $count_of_nodes_found / $count_of_nodes_needed ) ) ) ;
        print $percent_complete_tenths . " % tenths" . "\n" ;
        $interval_counter = 0 ;
    }
    $interval_counter ++ ;


#--------------------------------------------------
#  Repeat the loop for the next line of raw data.

}




#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#
#  Subroutine:
#
#  convert_into_loc_format
#
#--------------------------------------------------
#
#  Split the node latitude and longitude values
#  into a nines-complement integer notation
#  (which eliminates minus signs and decimal points).
#
#  Always use the same number of digits.
#
#--------------------------------------------------

sub convert_into_loc_format
{

    ( $latitude_int , $latitude_dec ) = split( /\./ , $latitude ) ;
    if ( $latitude_int =~ /-/ )
    {
        $latitude_int =~ s/-// ;
        $latitude_int =~ tr/0123456789/9876543210/ ;
        $latitude_dec =~ tr/0123456789/9876543210/ ;
        $nine_digits_needed_for_latitude_integer_portion = 3 - length( $latitude_int ) ;
        $nine_digits_needed_for_latitude_decimal_portion = 7 - length( $latitude_dec ) ;
        if ( $nine_digits_needed_for_latitude_decimal_portion < 0 )
        {
            $nine_digits_needed_for_latitude_decimal_portion = 0 ;
        }
        $latitude_string = "0" . $nine_digits_of_count[ $nine_digits_needed_for_latitude_integer_portion ] . $latitude_int . $latitude_dec . $nine_digits_of_count[ $nine_digits_needed_for_latitude_decimal_portion ] ;
    } else
    {
        $zero_digits_needed_for_latitude_integer_portion = 3 - length( $latitude_int ) ;
        $zero_digits_needed_for_latitude_decimal_portion = 7 - length( $latitude_dec ) ;
        if ( $zero_digits_needed_for_latitude_decimal_portion < 0 )
        {
            $zero_digits_needed_for_latitude_decimal_portion = 0 ;
        }
        $latitude_string = "1" . $zero_digits_of_count[ $zero_digits_needed_for_latitude_integer_portion ] . $latitude_int . $latitude_dec . $zero_digits_of_count[ $zero_digits_needed_for_latitude_decimal_portion ] ;
    }
    ( $longitude_int , $longitude_dec ) = split( /\./ , $longitude ) ;
    if ( $longitude_int =~ /-/ )
    {
        $longitude_int =~ s/-// ;
        $longitude_int =~ tr/0123456789/9876543210/ ;
        $longitude_dec =~ tr/0123456789/9876543210/ ;
        $nine_digits_needed_for_longitude_integer_portion = 3 - length( $longitude_int ) ;
        $nine_digits_needed_for_longitude_decimal_portion = 7 - length( $longitude_dec ) ;
        if ( $nine_digits_needed_for_longitude_decimal_portion < 0 )
        {
            $longitude_dec = substr( $longitude_dec , 0 , 7 ) ;
            $nine_digits_needed_for_longitude_decimal_portion = 0 ;
        }
        $longitude_string = "0" . $nine_digits_of_count[ $nine_digits_needed_for_longitude_integer_portion ] . $longitude_int . $longitude_dec . $nine_digits_of_count[ $nine_digits_needed_for_longitude_decimal_portion ] ;
    } else
    {
        $zero_digits_needed_for_longitude_integer_portion = 3 - length( $longitude_int ) ;
        $zero_digits_needed_for_longitude_decimal_portion = 7 - length( $longitude_dec ) ;
        if ( $zero_digits_needed_for_longitude_decimal_portion < 0 )
        {
            $longitude_dec = substr( $longitude_dec , 0 , 7 ) ;
            $zero_digits_needed_for_longitude_decimal_portion = 0 ;
        }
        $longitude_string = "1" . $zero_digits_of_count[ $zero_digits_needed_for_longitude_integer_portion ] . $longitude_int . $longitude_dec . $zero_digits_of_count[ $zero_digits_needed_for_longitude_decimal_portion ] ;
    }
    $location_loc = $latitude_string . " " . $longitude_string ;
    return $location_loc ;


#--------------------------------------------------
#  End of subroutine.

}
