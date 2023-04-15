#--------------------------------------------------
#       osm_get_max_min_lats_lons_for_ways.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_max_min_lats_lons_for_ways.pl


#--------------------------------------------------
#  Specify Linux or Windows path style.

# $slash_or_backslash = "\\" ;  # windows
$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Read each line of info, get the latitude and
#  longitude, and combine those numbers with other
#  latitudes and longitudes that are associated with
#  the same ID.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    $data_type = "" ;

    if ( $input_line =~ /^(l) +([0-9]+) +([0-9]+) +(n[0-9]+) +(w[0-9]+) *$/ )
    {
        $data_type = $1 ;
        $latitude = $2 ;
        $longitude = $3 ;
        $intermediate_node_way_relation_id = $4 ;
        $node_way_relation_id = $5 ;
        $remainder_of_line = "" ;
    }

    if ( $data_type ne "" )
    {
        if ( exists( $max_latitude_for_id{ $node_way_relation_id } ) )
        {
            if ( $latitude > $max_latitude_for_id{ $node_way_relation_id } )
            {
                $max_latitude_for_id{ $node_way_relation_id } = $latitude ;
            }
            if ( $latitude < $min_latitude_for_id{ $node_way_relation_id } )
            {
                $min_latitude_for_id{ $node_way_relation_id } = $latitude ;
            }
            if ( $longitude > $max_longitude_for_id{ $node_way_relation_id } )
            {
                $max_longitude_for_id{ $node_way_relation_id } = $longitude ;
            }
            if ( $longitude < $min_longitude_for_id{ $node_way_relation_id } )
            {
                $min_longitude_for_id{ $node_way_relation_id } = $longitude ;
            }
        } else
        {
            $data_type_for_id{ $node_way_relation_id } = $data_type ;
            $max_latitude_for_id{ $node_way_relation_id } = $latitude ;
            $min_latitude_for_id{ $node_way_relation_id } = $latitude ;
            $max_longitude_for_id{ $node_way_relation_id } = $longitude ;
            $min_longitude_for_id{ $node_way_relation_id } = $longitude ;
            $remainder_of_line_for_id{ $node_way_relation_id } = $remainder_of_line ;
        }
    }
}


#--------------------------------------------------
#  Loop through the node data based on the last two
#  digits of the node ID number.

for ( $ending_two_digits_as_integer = 0 ; $ending_two_digits_as_integer <= 99 ; $ending_two_digits_as_integer ++ )
{


#--------------------------------------------------
#  Create text versions of variations of the
#  ending digits.

    $ending_two_digits_as_text = sprintf( "%02d" , $ending_two_digits_as_integer ) ;

    $first_of_ending_two_digits_as_text = substr( $ending_two_digits_as_text , 0 , 1 ) ;

    $second_of_ending_two_digits_as_text = substr( $ending_two_digits_as_text , 1 , 1 ) ;

    print "\n" . "ending digits " . $ending_two_digits_as_text . "\n" ;


#--------------------------------------------------
#  Create integers that represent the ending two
#  digits in bcd -- binary coded decimal -- format.
#  The decimal number 48 is the ascii code
#  for the digit zero (0).

    $first_of_ending_two_digits_in_bcd_format = ord( $first_of_ending_two_digits_as_text ) - 48 ;

    $second_of_ending_two_digits_in_bcd_format = ord( $second_of_ending_two_digits_as_text ) - 48 ;

    $ending_two_digits_in_bcd_format = ( $first_of_ending_two_digits_in_bcd_format * 16 ) + $second_of_ending_two_digits_in_bcd_format ;


#--------------------------------------------------
#  Open the input file that contains the nodes,
#  latitudes, and longitudes in packed binary
#  format.

#  For testing:
#    $input_filename = 'output_packed_lats_lons_in_group_01.bin' ;

    $input_filename = 'lats_lons_in_groups' . $slash_or_backslash . 'output_packed_lats_lons_in_group_' . $ending_two_digits_as_text . '.bin' ;
    open( IN_FILE , '<' , $input_filename ) ;
    print "binary in: " . $input_filename . "\n" ;


#--------------------------------------------------
#  Begin a loop that handles each group of nine
#  packed integers from the input file.  These
#  integers hold the node ID and latitude and
#  longitude for one node.

    $intersection_count = 0 ;
    $progress_counter = 0 ;
    $log_line_counter = 0 ;
    while( read( IN_FILE , $two_bytes_in_integer[ 1 ] , 2 ) )
    {
        for ( $integer_position = 2 ; $integer_position <= 9 ; $integer_position ++ )
        {
            if ( not( read( IN_FILE , $two_bytes_in_integer[ $integer_position ] , 2 ) ) )
            {
                last ;
            }
        }


#--------------------------------------------------
#  Begin a loop that handles each way that includes
#  the current node ID as part of that way.

if ( exists( $list_of_way_ids_for_node{ $node_id } ) )
{
    $list_of_way_ids_as_text = $list_of_way_ids_for_node( $node_id ) ;
    @list_of_way_ids = split( /_/ , $list_of_way_ids_as_text ) ;
    foreach $way_id ( @list_of_way_ids )
    {

    }
}


#--------------------------------------------------
#  Get the node number in text format.  The final
#  two digits are already known to match the
#  ending digits being handled.
#  Each integer contains four digits in bcd --
#  binary coded decimal -- format.
#  Reminder: The modulo ("%") operator retrieves
#  one digit from the least-significant end of the
#  integer.
#  Decimal 2458 equals bcd 1000.
#  Decimal 2457 equals bcd 999.
#  Decimal 39321 equals bcd 9999.

        for ( $integer_position = 1 ; $integer_position <= 3 ; $integer_position ++ )
        {
            $four_bcd_digits_in_integer[ $integer_position ] = unpack( "S" , $two_bytes_in_integer[ $integer_position ] ) ;
            $integer_holding_four_bcd_digits = $four_bcd_digits_in_integer[ $integer_position ] ;
            $character_position = ( ( $integer_position - 1 ) * 4 ) + 4 ;
            for ( $count_of_digits_retrieved_from_integer = 1 ; $count_of_digits_retrieved_from_integer <= 4 ; $count_of_digits_retrieved_from_integer ++ )
            {
                $bcd_number_at_character_position[ $character_position ] = $integer_holding_four_bcd_digits % 16 ;
                $integer_holding_four_bcd_digits = int( $integer_holding_four_bcd_digits / 16 ) ;
                $character_position -- ;
            }
        }
        $node_number_full = "" ;
        for ( $character_position = 1 ; $character_position <= 12 ; $character_position ++ )
        {
            $node_number_full = $node_number_full . chr( $bcd_number_at_character_position[ $character_position ] + 48 ) ;
        }
        $node_number_truncated = substr( $node_number_full , 0 , 10 ) ;
        $node_number_truncated =~ s/^0+// ;
        if ( length( $node_number_truncated ) == 0 )
        {
            $node_number_truncated = "0" ;
        }
#        print OUT_FILE "[" . $node_number_full . "][" . $node_number_truncated . "]" . "\n" ;


#--------------------------------------------------
#  Display progress.

        $progress_counter ++ ;
        if ( $progress_counter > 10000000 )
        {
            $progress_counter = 0 ;
            $log_line_counter ++ ;
            print "handled next 10,000,000 nodes (" . $log_line_counter . ")" . "\n" ;
        }


#--------------------------------------------------
#  If this node is not an intersection (and
#  associated with at least one pair of way ID
#  numbers), restart the node loop to handle the
#  next node.

        if ( not( exists( $street_ids_for_truncated_node{ $node_number_truncated } ) ) )
        {
            next ;
        }



#--------------------------------------------------
#  Clear the info that was collected for the
#  previous pair of ending digits.

    %bounding_box_for_way = ( ) ;


#--------------------------------------------------
#  Open the current output file.

    $output_filename = 'output_intersections_with_lats_lons_group_' . $first_of_ending_two_digits_as_text . '.txt' ;
    print "output filename: " . $output_filename . "\n" ;
    open( OUT_FILE, '>>' , $output_filename ) or die $! ;


#--------------------------------------------------
#  Specify the file that contains the node and way
#  pairs.

    $input_filename = 'lats_lons_in_groups' . $slash_or_backslash . 'lats_lons_ways_in_group_' . $ending_two_digits_as_text . '.txt' ;


#--------------------------------------------------
#  Repeat the loop for the next node data based on
#  the last two digits of the node ID number.

}

