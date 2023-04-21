#--------------------------------------------------
#       osm_merge_lats_lons_with_way_relation_ids.pl
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
#
#
#  Merges the latitude and longitude locations of
#  city or business nodes with city or business way
#  and relation IDs so that the centers of
#  bounding boxes can be calculated.
#
#  Usage:
#
#  perl osm_merge_lats_lons_with_way_relation_ids.pl


#--------------------------------------------------
#  Input format:
#
#  The first two digits must match the ending two
#  digits in the node number, and the file must be
#  sorted by the two digits so that the same two
#  digits do not appear later in the file.

#  00 n1017500 w574529215
#  00 n1077800 w440112538
#  00 n1077900 w86163852
#  00 n1078100 w440112444
#  00 n1078200 w440112444
#  01 n1017501 w574529215
#  01 n1077801 w440112538
#  01 n1077901 w86163852
#  01 n1078101 w440112444
#  01 n1078201 w440112444


#--------------------------------------------------
#  Output format:
#
#  w89737702 10585974561 10162359387
#  w52120510 10483886317 10109156389
#  w73908440 10599808984 10303269180
#  w180860990 10599866293 10303573954
#  r769650408 10586676239 10334573989


#--------------------------------------------------
#  Specify Linux or Windows path style.

# $slash_or_backslash = "\\" ;  # windows
$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Open the input file that contains the node and
#  way pairs and the node and relation pairs.  Each
#  line is preceded by the ending two digits of the
#  node ID.  The ending digits were used to sort
#  the lines based on the ending two digits.

$input_filename = 'output_sorted_node_and_way_or_relation_pairs.txt' ;
print "input filename: " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;


#--------------------------------------------------
#  Open the output files.

$output_filename = 'output_outline_ways_relations_with_lats_lons.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_FILE, '>' , $output_filename ) or die $! ;

$output_filename = 'output_log_from_merge_lats_lons.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_LOG, '>' , $output_filename ) or die $! ;


#--------------------------------------------------
#  Begin a loop that gets the next node and way
#  pair, or the next node and relation pair.

$node_number_as_text = "" ;
$ending_two_digits_as_text = "00" ;
while ( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^[0-9][0-9] +n([0-9]+([0-9][0-9])) +([wr][0-9]+)/ )
    {
        $next_node_number_as_text = $1 ;
        $next_ending_two_digits_as_text = $2 ;
        $next_way_or_relation_id = $3 ;
    } else
    {
        print OUT_LOG "unrecognized: [" . $input_line . "]" . "\n" ;
        $count_of_lines_not_recognized ++ ;
        next ;
    }


#--------------------------------------------------
#  If the ending two digits have changed, get and
#  write the latitudes and longitudes for the nodes
#  that end with the previous ending two digits,
#  and then clear the associative array for the
#  next ending two digits.

    if ( $next_ending_two_digits_as_text ne $ending_two_digits_as_text )
    {
        &get_and_write_latitudes_longitudes_for_ways_relations( ) ;
        %ways_relations_that_include_truncated_node = ( ) ;
    }


#--------------------------------------------------
#  Begin to handle the new node and way pair.

    $node_number_as_text = $next_node_number_as_text ;
    $ending_two_digits_as_text = $next_ending_two_digits_as_text ;
    $way_or_relation_id = $next_way_or_relation_id ;


#--------------------------------------------------
#  If the node number is short, pad it with leading
#  zeros.

    $character_length = length( ( $node_number_as_text . "" ) ) ;
    if ( $character_length < 4 )
    {
        $node_number_as_text = substr( "0000" , 0 , ( 4 - $character_length ) ) . $node_number_as_text ;
    }


#--------------------------------------------------
#  Append the way ID number or relation ID number
#  to a sub-list that is associated with this node
#  ID.  The sub-list lists the ways and relations
#  that include that node in their list of points
#  (nodes).  The index to the main list of nodes
#  uses a truncated node ID because the last two
#  digits are the same as a result of handling
#  all such node ID endings together (before
#  progressing to the next ID ending).
#  Omitting the last two unchanging digits
#  increases processing speed (and uses less
#  memory).

    $node_number_truncated = substr( $node_number_as_text , 0 , ( length( $node_number_as_text . "" ) - 2 ) ) ;

    $ways_relations_that_include_truncated_node{ $node_number_truncated } = $ways_relations_that_include_truncated_node{ $node_number_truncated } . $way_or_relation_id . " " ;


#    print OUT_LOG "[" . $node_number_as_text . "][" . $node_number_truncated . "][" . $way_or_relation_id . "][" . $ways_relations_that_include_truncated_node{ $node_number_truncated } . "]" . "\n" ;




#--------------------------------------------------
#  Repeat the loop to handle the next line in the
#  input file.

}


#--------------------------------------------------
#  Handle the final group of node ID numbers, which
#  have 99 as the ending two digits.

&get_and_write_latitudes_longitudes_for_ways_relations( ) ;


#--------------------------------------------------
#  Write some log info including a list of the
#  nodes that were not found.

foreach $node_number_truncated ( keys( %ways_relations_that_include_truncated_node ) )
{



#    print OUT_LOG "[" . $ways_relations_that_include_truncated_node{ $node_number_truncated } . "]" . "\n" ;



    if ( $ways_relations_that_include_truncated_node{ $node_number_truncated } !~ /found/ )
    {
        print OUT_LOG "not found: n" . $node_number_truncated . $ending_two_digits_as_text . "\n" ;
        $count_of_nodes_not_found ++ ;
    }
}
print "skipped " . $count_of_lines_not_recognized . " input lines not recognized" . "\n" ;
print "counted " . $count_of_nodes_not_found . " node IDs not found" . "\n" ;


#--------------------------------------------------
#  End of main code.

exit( ) ;


#--------------------------------------------------
#  Subroutine that gets latitudes and longitudes
#  and writes to the output file.

sub get_and_write_latitudes_longitudes_for_ways_relations
{


#--------------------------------------------------
#  If testing is being done and there are no
#  node IDs that have the specified ending two
#  digits, return without reading the associated
#  latitude and longitude file.

    if ( keys( %ways_relations_that_include_truncated_node ) < 1 )
    {
        return ;
    }


#--------------------------------------------------
#  Create an integer that represents the ending two
#  digits in bcd -- binary coded decimal -- format.
#  The decimal number 48 is the ascii code
#  for the digit zero (0).

    $first_of_ending_two_digits_as_text = substr( $ending_two_digits_as_text , 0 , 1 ) ;

    $second_of_ending_two_digits_as_text = substr( $ending_two_digits_as_text , 1 , 1 ) ;

    $first_of_ending_two_digits_in_bcd_format = ord( $first_of_ending_two_digits_as_text ) - 48 ;

    $second_of_ending_two_digits_in_bcd_format = ord( $second_of_ending_two_digits_as_text ) - 48 ;

    $ending_two_digits_in_bcd_format = ( $first_of_ending_two_digits_in_bcd_format * 16 ) + $second_of_ending_two_digits_in_bcd_format ;


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
#  longitude for one node.

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
#  If this node is not of interest, restart the
#  node loop to handle the next node.

        if ( not( exists( $ways_relations_that_include_truncated_node{ $node_number_truncated } ) ) )
        {
             next ;
        }


#--------------------------------------------------
#  Get the latitude and longitude integers as text.
#  They are 11 digits in length.  Ignore the first
#  digit in each group of 12 digits.

        $latitude = substr( $digits_node_lat_lon , 13 , 11 ) ;
        $longitude = substr( $digits_node_lat_lon , 25 , 11 ) ;

#        print OUT_LOG "latitude and longitude: " . $latitude . " " . $longitude . "\n" ;


#--------------------------------------------------
#  For each of the way IDs that include this node,
#  write the way ID and the latitude and longitude
#  for this node.  The node ID is not included.
#  Later steps (in other scripts) will find the
#  maximum and minimum latitude and longitude for
#  each way, and these define the bounding box for
#  this way ID.  When there is a duplicate way
#  or relation ID in the list, omit the
#  duplicates.

        $list_of_way_or_relation_ids_as_text = $ways_relations_that_include_truncated_node{ $node_number_truncated } ;
        if ( index( $list_of_way_or_relation_ids_as_text , " " ) < 0 )
        {
            @list_of_way_or_relation_ids = ( $list_of_way_or_relation_ids_as_text ) ;
        } else
        {
            @list_of_way_or_relation_ids = split( / / , $list_of_way_or_relation_ids_as_text ) ;
        }
        $previous_way_or_relation_id = "" ;
        foreach $way_or_relation_id ( @list_of_way_or_relation_ids )
        {
            if ( ( $way_or_relation_id =~ /^ *$/ ) || ( $way_or_relation_id eq $previous_way_or_relation_id ) )
            {
                next ;
            }
            print OUT_FILE $way_or_relation_id . " " . $latitude . " " . $longitude . "\n" ;
            $previous_way_or_relation_id = $way_or_relation_id ;
        }
        $ways_relations_that_include_truncated_node{ $node_number_truncated } .= " found" ;


#--------------------------------------------------
#  Repeat the loop to consider the next node in
#  the binary file that contains the node's
#  latitude and longitude numbers.

    }


#--------------------------------------------------
#  End of subroutine.

    close( IN_FILE_BINARY ) ;
    return ;
}


#--------------------------------------------------
#  End of code.

