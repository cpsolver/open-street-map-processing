#--------------------------------------------------
#       osm_put_centers_into_city_or_biz_info.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com
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
#  Usage:
#
#  perl osm_put_centers_into_city_or_biz_info.pl


#--------------------------------------------------
#  Input format for way and relation info:
#
#  c w2240370 links_n9697706_n1756935475_n4475544737_n4475544736_n9791102363_n9697704_ Steinbruchstra&#223;e no_label no_alt_name lang_count_0 admin_level_9 boundary_administrative no_is_in
#
#  c r4569 links_w202164033_w949200140_w87267396_w523670185_w168704636_w168704618_w168833167_w88734972_w88736728_w168833169_w160221480_w1089391628_w371873106_w371873105_w784901516_w371874263_w690067607_w745779454_w371870255_w168833166_w745779451_w87267339_ Knokke-Heist label_at_n1395162377 no_alt_name lang_count_3 admin_level_8 boundary_administrative population_33556 no_is_in
#
#  b r123 ...


#--------------------------------------------------
#  Input format for bounding box info:

#  w152205341 10283760660 10283798762 09183597399 09183597433
#  w30823940 10439041501 10439150189 10000697813 10000747840
#  w675744077 10237319139 10237350369 11206558222 11206596180
#  r4557 10473621638 10473718951 10089848883 10090400516


#--------------------------------------------------
#  Output format, which matches node format.
#
#  Way format:
#  01234523428 01234523428 w2240370 Steinbruchstra&#223;e no_alt_name lang_count_0 admin_level_9 boundary_administrative no_is_in
#
#  Relation format:
#  01234523428 01234523428 r4569 Knokke-Heist label_at_n1395162377 no_alt_name lang_count_3 admin_level_8 boundary_administrative population_33556 no_is_in
#
#  Node format:
#  10356823815 11397530053 n265018692 &#26481;&#20140;&#37117; no_label name&#58;en_Tokyo lang_count_41 admin_level_2 place_city population_12790000  is_in:country_Japan is_in:country_code_JP is_in:island_Honshu links_


#--------------------------------------------------
#  Open the output file.

$output_filename = 'output_city_or_biz_info_with_centers.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_FILE, '>' , $output_filename ) or die $! ;


#--------------------------------------------------
#  Open an output log file that indicates item IDs
#  for which a center was not identified.

$output_log_filename = 'output_log_put_centers_unrecognized.txt' ;
print "output log filename: " . $output_log_filename . "\n" ;
open( OUT_LOG, '>' , $output_log_filename ) or die $! ;


#--------------------------------------------------
#  Get the bounding box info.

$input_filename = 'output_bounding_boxes_for_ways_and_relations.txt' ;
print "input filename: " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;
while ( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([wr][0-9]+) +([0-9]{11} +[0-9]{11} +[0-9]{11} +[0-9]{11})/ )
    {
        $item_id = $1 ;
        $bounding_box = $2 ;
        $bounding_box_for_item_id{ $item_id } = $bounding_box ;
        $count_of_boxes_recognized ++ ;
    } else
    {
        print OUT_LOG "unrecognized: [" . $input_line . "]" . "\n" ;
        $count_of_boxes_not_recognized ++ ;
    }
}
close( IN_FILE ) ;
print "recognized " . $count_of_boxes_recognized . " bounding boxes" . "\n" ;
print "not recognized " . $count_of_boxes_not_recognized . " bounding boxes" . "\n" ;


#--------------------------------------------------
#  Open the input file that contains the info
#  needing centers.

$input_filename = 'output_city_or_biz_info_needing_centers.txt' ;
print "input filename: " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;


#--------------------------------------------------
#  Begin a loop that handles the next line of text
#  in the file.

while ( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    $input_line_raw = $input_line ;


#--------------------------------------------------
#  Initialize the values that can be retrieved from
#  the line.

    $latitude_and_longitude = "" ;
    $item_id = "" ;
    $item_name = "" ;
    $item_ids_in_links = "" ;
    $remainder_of_line = "" ;
    $node_id_at_label =  "" ;


#--------------------------------------------------
#  If the line begins with "c" or "b" to indicate
#  city or business, remove it.  It was only needed
#  where both kinds of data are handled at the same
#  time.

    if ( $input_line =~ /^[cb] +(.+)$/ )
    {
        $input_line = $1 ;
    }


#--------------------------------------------------
#  Get the way ID or relation ID or node ID that
#  this information refers to.

    if ( $input_line =~ /([nwr][0-9]+)/ )
    {
        $line_item_id = $1 ;
    }


#--------------------------------------------------
#  If the latitude and longitude are at the
#  beginning of the line, get them, and remove them
#  from the input line.  They will be re-inserted
#  later.

    if ( $input_line =~ /^([0-9]{11} +[0-9]{11}) +(.*)$/ )
    {
        $latitude_and_longitude = $1 ;
        $input_line = $2 ;
    }


#--------------------------------------------------
#  If there is a "label_at_" entry, remove it
#  because that information already was converted
#  into a bounding box that has zero width and
#  zero height.

    if ( $input_line =~ /^(.*) label_at_n[0-9]+(.*)$/ )
    {
        $input_line = $1 . $2 ;
    }


#--------------------------------------------------
#  If the line refers to a way ID or relation ID
#  that is associated with a bounding box, use that
#  bounding box.  If there is not an associated
#  bounding box and there is a "links_" entry that
#  lists way IDs (and possibly some node IDs), put
#  those way IDs into a list.  Nothing needs to be
#  done if the line refers to a single node ID.

    if ( exists( $bounding_box_for_item_id{ $line_item_id } ) )
    {
        $item_ids_in_links = $line_item_id ;
    } elsif ( $input_line =~ / links_([nw0-9_]+)/ )
    {
        $item_ids_in_links = $1 ;
    } else
    {
        $item_ids_in_links = "" ;
    }


#--------------------------------------------------
#  Split the list of item IDs into an array and
#  begin a loop that handles each item ID.  If the
#  information applies to a single item ID, there
#  is only one way or relation ID in the list.

    if ( $item_ids_in_links =~ /_/ )
    {
        @list_of_item_ids_in_links = split( /_/ , $item_ids_in_links ) ;
    } else
    {
        @list_of_item_ids_in_links = ( $item_ids_in_links ) ;
    }
    $latitude_minimum_integer = 99999999999 ;
    $latitude_maximum_integer = 0 ;
    $longitude_minimum_integer = 99999999999 ;
    $longitude_maximum_integer = 0 ;
    foreach $item_id ( @list_of_item_ids_in_links )
    {
        $way_box_latitude_minimum = "0" ;
        $way_box_latitude_maximum = "0" ;
        $way_box_longitude_minimum = "0" ;
        $way_box_longitude_maximum = "0" ;


#--------------------------------------------------
#  Get the bounding box that is associated with
#  this item ID.  If a bounding box is missing,
#  the location will be determined from the other
#  bounding boxes that are available.

        if ( $item_id =~ /^[wr][0-9]+$/ )
        {
            if ( exists( $bounding_box_for_item_id{ $item_id } ) )
            {
                $bounding_box_for_way = $bounding_box_for_item_id{ $item_id } ;
                if ( $bounding_box_for_way =~ /([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)/ )
                {
                    $way_box_latitude_minimum = $1 ;
                    $way_box_latitude_maximum = $2 ;
                    $way_box_longitude_minimum = $3 ;
                    $way_box_longitude_maximum = $4 ;
 
#  debugging code if needed:
#                    $debug_line_counmter ++ ;
#                    if ( $debug_line_counmter < 200 )
#                    if ( $line_item_id eq "r50046" )
#                    {
#                        print OUT_LOG "debug info: [" . $input_line_raw . "] [" . $item_id . "] [" . $bounding_box_for_way . "]" . "\n" ;
#                    }

               } else
               {
                   print OUT_LOG "bounding box " . $item_id . " format flawed " . $bounding_box_for_way . "\n" ;
               }
            } else
            {

#  debugging code if needed:
#                if ( $debug_line_counmter < 200 )
#                if ( $line_item_id eq "r50046" )
#                {
#                    print OUT_LOG "bounding box for " . $item_id . " not found" . "\n" ;
#                }

            }
        }


#--------------------------------------------------
#  Extend the full bounding box to fit the smaller
#  bounding box within it.

        if ( $way_box_latitude_minimum ne "" )
        {
            if ( ( $way_box_latitude_minimum + 0 ) < $latitude_minimum_integer )
            {
                $latitude_minimum_integer = $way_box_latitude_minimum + 0 ;
            }
            if ( ( $way_box_latitude_maximum + 0 ) > $latitude_maximum_integer )
            {
                $latitude_maximum_integer = $way_box_latitude_maximum + 0 ;
            }
            if ( ( $way_box_longitude_minimum + 0 ) < $longitude_minimum_integer )
            {
                $longitude_minimum_integer = $way_box_longitude_minimum + 0 ;
            }
            if ( ( $way_box_longitude_maximum + 0 ) > $longitude_maximum_integer )
            {
                $longitude_maximum_integer = $way_box_longitude_maximum + 0 ;
            }
        }


#--------------------------------------------------
#  Repeat the loop to handle the next way ID or
#  node ID.

    }


#--------------------------------------------------
#  Calculate the overall bounding box and the
#  center of that full bounding box.  If a center
#  cannot be calculated, leave the
#  "latitude_and_longitude" variable empty.

    if ( ( $latitude_minimum_integer != 99999999999 ) && ( $latitude_maximum_integer != 0 ) && ( $longitude_minimum_integer != 99999999999 ) && ( $longitude_maximum_integer != 0 ) )
    {
        $latitude_center = int( ( $latitude_minimum_integer + $latitude_maximum_integer ) / 2 ) ;
        $longitude_center = int( ( $longitude_minimum_integer + $longitude_maximum_integer ) / 2 ) ;
        $latitude_and_longitude = sprintf( "%011d" , $latitude_center ) . " " . sprintf( "%011d" , $longitude_center ) ;
    }


#--------------------------------------------------
#  If there is a "links_" entry, remove it.

    if ( $input_line =~ /^(.*) links_[nw0-9_]+(.*)$/ )
    {
        $input_line = $1 . $2 ;
    }


#--------------------------------------------------
#  If the latitude and longitude are known, put
#  them at the beginning of the line, and write
#  the modified (or possibly unmodified) line.

    if ( $latitude_and_longitude ne "" )
    {
        $input_line = $latitude_and_longitude . " " . $input_line ;
        print OUT_FILE $input_line . "\n" ;
    }


#--------------------------------------------------
#  If the latitude and longitude is not known,
#  indicate this error.

    if ( ( $latitude_and_longitude eq "" ) && ( $input_line_raw =~ /[^ ]/ ) )
    {
        print OUT_LOG "unknown location: [" . $input_line_raw . "] [" . $item_ids_in_links . "]" . "\n" ;
        $count_of_lines_not_recognized ++ ;
    }


#--------------------------------------------------
#  Repeat the loop that handles the next line.

}


#--------------------------------------------------
#  Close the second input file.

close( IN_FILE ) ;


#--------------------------------------------------
#  Close the output file and write some log info.

close( OUT_FILE ) ;
print "skipped " . $count_of_lines_not_recognized . " lines not recognized" . "\n" ;


#--------------------------------------------------
#  End of code.

