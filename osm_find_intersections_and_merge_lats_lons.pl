#--------------------------------------------------
#       osm_find_intersections_and_merge_lats_lons.pl
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
#  Merges the latitude and longitude locations of
#  intersection nodes with the pair of way IDs (or
#  relation IDs) that will provide a name for the
#  intersection.
#
#  Usage:
#
#  First, delete files named:
#  output_intersections_with_lats_lons_group_0.txt
#  output_intersections_with_lats_lons_group_1.txt
#  etc.  Then:
#
#  perl osm_find_intersections_and_merge_lats_lons.pl


#--------------------------------------------------
#  Intput files and format:

# street_node_way_pairs/node_way_pairs_in_group_00.txt
#
# n1105988000 r8715
# n809204700 r20605
# n7757174800 r178385
# n533792800 r291250
# n1568452400 r335422
# n7884603500 r398208
# n10695965600 w1149774142
# n140923700 w1149774191
# n10695963500 w1149774291
#
# street_node_way_pairs/node_way_pairs_in_group_82.txt
#
# n192905382 w429222842
# n192905382 w46966597
# n192905382 w265525492


#--------------------------------------------------
#  Output format:
#
#  0922_1166 w133795298 w191725117 1547107 6695210
#  1059_1010 w70540449 w1085257263 9257533 7784759
#  1059_1010 w4982896 w4982993 9601198 7884770
#  1059_1010 w4982896 w85836202 9601198 7884770
#
#  0965_0941 w22697214 w265525492 4054423 6141862
#  0965_0941 w265525489 w265525492 4054423 6141862
#  0965_0941 w46966597 w265525492 4055241 6155774
#  0965_0941 w265525492 w429222842 4055241 6155774
#  0965_0941 w265525492 w301282953 4056768 6170464


#--------------------------------------------------
#  Specify Linux or Windows path style.

# $slash_or_backslash = "\\" ;  # windows
$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Loop through the data based on the last two
#  digits of the node ID number.

#  for testing:
# for ( $ending_two_digits_as_integer = 1 ; $ending_two_digits_as_integer <= 2 ; $ending_two_digits_as_integer ++ )

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
#  Clear the info that was collected for the
#  previous pair of ending digits.

    %ways_and_relations_at_truncated_node = ( ) ;


#--------------------------------------------------
#  Do initialization for this pair of ending
#  digits.

    $line_count = 0 ;
    $node_match_count = 0 ;
    $count_of_lines_not_recognized = 0 ;


#--------------------------------------------------
#  Open the current output file.

    $output_filename = 'output_intersections_with_lats_lons_group_' . $first_of_ending_two_digits_as_text . '.txt' ;
    print "output filename: " . $output_filename . "\n" ;
    open( OUT_FILE, '>>' , $output_filename ) or die $! ;


#--------------------------------------------------
#  Open the input file that contains the node and
#  way pairs and node and relation pairs.

    $input_filename = 'street_node_way_pairs' . $slash_or_backslash . 'node_way_pairs_in_group_' . $ending_two_digits_as_text . '.txt' ;
    open( IN_FILE_PAIRS , '<' , $input_filename ) ;


#--------------------------------------------------
#  Begin a loop that reads the list of node and
#  way pairs and node and relation pairs.

    while ( $input_line = <IN_FILE_PAIRS> )
    {
        chomp( $input_line ) ;
        $line_count ++ ;


#--------------------------------------------------
#  Get the node ID and the way or relation ID,
#  which is one "pair" of items.

        if ( $input_line =~ /n([0-9]+) +([wr][0-9]+)/ )
        {
            $node_number_as_text = $1 ;
            $way_or_relation_number_as_text = $2 ;
        } else
        {
#            print "unrecognized: [" . $input_line . "]" . "\n" ;
            $count_of_lines_not_recognized ++ ;
            next ;
        }


#--------------------------------------------------
#  If the node number is short, pad it with leading
#  zeros.

        $character_length = length( ( $node_number_as_text . "" ) ) ;
        if ( $character_length < 4 )
        {
            $node_number_as_text = substr( "0000" , 0 , ( 4 - $character_length ) ) . $node_number_as_text ;
        }


#--------------------------------------------------
#  If the ending two digits of the node number do
#  not match the ones being handled, repeat the
#  loop.

        if ( substr( $node_number_as_text , -2 , 2 ) ne $ending_two_digits_as_text )
        {
            print "found node ID with unexpected ending digits: [" . $input_line . "]" . "\n" ;
            next ;
        }


#--------------------------------------------------
#  Append the way ID number or relation ID number
#  to a sub-list that is associated with this node
#  ID.  The sub-list lists the street ways and
#  relations that include this node in their list
#  of points (nodes).
#  The index to the the sub-lists uses a
#  truncated node ID because the last two digits
#  are always the same.  Omitting those last two
#  unchanging digits increases processing speed.

        $node_number_truncated = substr( $node_number_as_text , 0 , ( length( $node_number_as_text . "" ) - 2 ) ) ;
        $ways_and_relations_at_truncated_node{ $node_number_truncated } = $ways_and_relations_at_truncated_node{ $node_number_truncated } . $way_or_relation_number_as_text . " " ;
#        print OUT_FILE "[" . $node_number_as_text . "][" . $node_number_truncated . "][" . $way_or_relation_number_as_text . "][" . $ways_and_relations_at_truncated_node{ $node_number_truncated } . "]" . "\n" ;
        $node_match_count ++ ;


#--------------------------------------------------
#  Repeat the loop to handle the next line in the
#  input file that lists the node and way and
#  relation pairs.

    }


#--------------------------------------------------
#  Close the input file and write some log info.

    close( IN_FILE_PAIRS ) ;
    if ( $count_of_lines_not_recognized > 0 )
    {
        print "skipped " . $count_of_lines_not_recognized . " lines not recognized" . "\n" ;
    }
    print "got " . $node_match_count . " nodes from " . $line_count . " node street pairs in file " . $input_filename . "\n" ;


#--------------------------------------------------
#  If testing and no nodes of interest were found,
#  restart the loop to handle the next ending
#  digits.

    if ( $node_match_count < 1 )
    {
        print "test does not have nodes for these ending digits" . "\n" ;
        next ;
    }


#--------------------------------------------------
#  Copy the items in the just-created list that
#  are associated with more than one street way
#  (or street relation).  These nodes are street
#  intersections.  After making this copy,
#  delete the associative array that was copied.

    $intersection_count = 0 ;
    %street_ids_for_truncated_node = ( ) ;
    foreach $node_number_truncated ( keys ( %ways_and_relations_at_truncated_node ) )
    {
        $ways_and_relations_for_one_node = $ways_and_relations_at_truncated_node{ $node_number_truncated } ;
        if ( index( $ways_and_relations_for_one_node , ' ' ) < ( length( $ways_and_relations_for_one_node ) - 1 ) )
        {
            $street_ids_for_truncated_node{ $node_number_truncated } = substr( $ways_and_relations_for_one_node , 0 , ( length( $ways_and_relations_for_one_node ) - 1 ) ) ;
#            print OUT_FILE "[" . $node_number_truncated . "][" . $street_ids_for_truncated_node{ $node_number_truncated } . "]" . "\n" ;
            $intersection_count ++ ;
        }
    }
    %ways_and_relations_at_truncated_node = ( ) ;
    print "found " . $intersection_count . " intersections" . "\n" ;


#--------------------------------------------------
#  If no intersections were found, restart the
#  loop to get node and way or relation pairs from
#  a different input file.

    if ( $intersection_count < 1 )
    {
        print "current ending digits skipped because no intersections found" . "\n" ;
        next ;
    }


#--------------------------------------------------
#  Open the input file that contains the nodes,
#  latitudes, and longitudes in packed binary
#  format.  It is specific to the current ending
#  two digits of node numbers.

    $input_filename = 'lats_lons_in_groups' . $slash_or_backslash . 'output_packed_lats_lons_in_group_' . $ending_two_digits_as_text . '.bin' ;
    open( IN_FILE_BINARY, '<:raw' , $input_filename ) or die $! ;
    print "binary in: " . $input_filename . "\n" ;


#--------------------------------------------------
#  Begin a loop that handles each group of nine
#  packed integers from the input file.  These
#  integers hold the node ID and latitude and
#  longitude for one node.  The nine packed
#  integers are stored in 18 bytes, and each
#  byte holds two digits.  Hexadecimal conversion
#  is used because in this case it matches
#  binary coded decimal format.

    $intersection_count = 0 ;
    $progress_counter = 0 ;
    $log_line_counter = 0 ;
    while( read( IN_FILE_BINARY , $bytes , 18 ) )
    {
        $digits_node_lat_lon = unpack( "h36" , $bytes ) ;


#--------------------------------------------------
#  Get the node number.  The final
#  two digits are already known to match the
#  ending digits being handled.
#  The leading zeros must be removed before
#  checking the truncated version with a match.

        $node_number_full = substr( $digits_node_lat_lon , 0 , 12 ) ;
        $node_number_truncated = substr( $node_number_full , 0 , 10 ) ;
        $node_number_truncated =~ s/^0+// ;
        if ( length( $node_number_truncated ) == 0 )
        {
            $node_number_truncated = "0" ;
        }

#        print OUT_LOG "-[" . $node_number_full . "][" . $node_number_truncated . "]" . "\n" ;



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
#  Get the latitude and longitude integers as text.
#  They are 11 digits in length.  Ignore the first
#  digit in each group of 12 digits because that
#  should always be zero.

        $latitude = substr( $digits_node_lat_lon , 13 , 11 ) ;
        $longitude = substr( $digits_node_lat_lon , 25 , 11 ) ;

#        print OUT_LOG "latitude and longitude: " . $latitude . " " . $longitude . "\n" ;


#--------------------------------------------------
#  The latitude and longitude are for a node that
#  is an intersection.  So get the first four
#  digits of the latitude and longitude integers
#  and combine them with an underscore to
#  specify a region.

        $region_latitude = substr( $digits_node_lat_lon , 13 , 4 ) ;
        $region_longitude = substr( $digits_node_lat_lon , 25 , 4 ) ;
        $latitude_truncated = substr( $digits_node_lat_lon , 17 , 7 ) ;
        $longitude_truncated = substr( $digits_node_lat_lon , 29 , 7 ) ;


#--------------------------------------------------
#  Begin a loop that pairs each street ID with each
#  of the other street IDs that also share the same
#  node ID.
#  A relation ID and way ID can refer to the same
#  street name, or the relation ID can provide a
#  second name for the street.
#  If both street IDs are the same, ignore this
#  pair of street IDs.

        @list_of_street_ids = split( / / , $street_ids_for_truncated_node{ $node_number_truncated } ) ;
        for ( $which_street_first = 0 ; $which_street_first < $#list_of_street_ids ; $which_street_first ++ )
        {
            $street_id_first = $list_of_street_ids[ $which_street_first ] ;
            for ( $which_street_second = $which_street_first + 1 ; $which_street_second <= $#list_of_street_ids ; $which_street_second ++ )
            {
                $street_id_second = $list_of_street_ids[ $which_street_second ] ;
                if ( $street_id_first eq $street_id_second )
                {
                    next ;
                }


#--------------------------------------------------
#  Write the info for one pair of street IDs.
#  The latitude and longitude are split into a
#  region -- which is identified by the first four
#  digits in the latitude and the first four digits
#  in the longitude -- and the remaining digits.
#  Write the smaller street ID first and the
#  larger street ID second.
#
#  Output format:
#  0922_1166 w133795298 w191725117 1547107 6695210

                if ( length( $street_id_first ) < length( $street_id_second ) )
                {
                    $both_street_ids = $street_id_first . " " . $street_id_second ;
                } elsif ( length( $street_id_second ) < length( $street_id_first ) )
                {
                    $both_street_ids = $street_id_second . " " . $street_id_first ;
                } else
                {
                    $street_id_first_as_number = 0 + substr( $street_id_first , 1 ) ;
                    $street_id_second_as_number = 0 + substr( $street_id_second , 1 ) ;
                    if ( $street_id_first_as_number < $street_id_second_as_number )
                    {
                        $both_street_ids = $street_id_first . " " . $street_id_second ;
                    } else
                    {
                        $both_street_ids = $street_id_second . " " . $street_id_first ;
                    }
                }
                print OUT_FILE $region_latitude . '_' . $region_longitude . ' ' . $both_street_ids . ' ' . $latitude_truncated . ' ' . $longitude_truncated . "\n"  ;
                $intersection_count ++ ;


#--------------------------------------------------
#  Repeat the loops for the next pair of street IDs
#  at the same intersection.

            }
        }


#--------------------------------------------------
#  Repeat the loop to consider the next node in
#  the binary file that contains the node and
#  latitude and longitude numbers.

    }


#--------------------------------------------------
#  Close the files for the current choice of last
#  two digits in the node ID number.

    close( OUT_FILE ) ;
    close( IN_FILE_BINARY ) ;


#--------------------------------------------------
#  Repeat the loop for the next group of nodes
#  that have the next pair of two ending digits.

    print "found " . $intersection_count . " matching intersections in this group" . "\n" ;
    $total_intersection_count += $intersection_count ;
}


#--------------------------------------------------
#  All done.

print "\n" ;
print "done, found " . $total_intersection_count . " intersections total" . "\n" ;


#--------------------------------------------------
#  End of code.

