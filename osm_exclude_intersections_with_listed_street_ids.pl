#--------------------------------------------------
#       osm_exclude_intersections_with_listed_street_ids.pl
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
#  perl osm_exclude_intersections_with_listed_street_ids.pl


#--------------------------------------------------
#  Sample input line for street IDs:

#  s w562988 links_n2988453_n5335589338_..._n2988464_ Munkestien highway_path  no_alt_name

#  s r1528050 links_n1233367784_w258503972_n1233367846_n2638485589_n2638485573_ Altenberg_Zinnwalder_Stra&#223;e highway_bus_stop  no_alt_name


#--------------------------------------------------
#  Sample input line for intersections:

#  0922_1166 w133795298 w191725117 1547107 6695210


#--------------------------------------------------
#  Initialization:

$yes_yes = 1 ;
$no_no = 0 ;


#--------------------------------------------------
#  Initialization.

$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Specify as the starting input filename the
#  name for the file that contains the
#  intersection info to be filtered.

$input_filename_to_filter = 'output_joined_intersection_info_before_exclusions.txt' ;


#--------------------------------------------------
#  Specify the filenames that will be used as
#  output filenames.

$output_filename_alpha = 'temp_partial_filtered_intersections_alpha.txt' ;
$output_filename_beta = 'temp_partial_filtered_intersections_beta.txt' ;
$output_filename_final = 'output_street_intersections_after_exclusions.txt' ;


#--------------------------------------------------
#  Initialize the output filename for the first
#  pass through the filter.

$output_filename_from_filter = $output_filename_alpha ;


#--------------------------------------------------
#  Open the file that contains the item IDs to
#  exclude.  The first item ID in each line will be
#  excluded.  The remainder of the line is
#  ignored.

$input_filename_exclusion_list = 'output_street_ids_to_exclude.txt' ;
print "input filename with ids to exclude: " . $input_filename_exclusion_list . "\n" ;
open( IN_FILE_IDS , '<' , $input_filename_exclusion_list ) ;


#--------------------------------------------------
#  Begin a loop that gets the next item ID to
#  exclude.

while( $input_item_id_line = <IN_FILE_IDS> )
{
    chomp( $input_item_id_line ) ;
    if ( $input_item_id_line =~ /([wr][0-9]+)/ )
    {
        $way_or_relation_id = $1 ;
        $yes_exclude_way_or_relation_id{ $way_or_relation_id } = $yes_yes ;
        $exclusion_id_count ++ ;


#--------------------------------------------------
#  If there are enough item IDs in the exclusion
#  list, exclude those items from the intersection
#  info.
#
#  This number controls how much memory is used by
#  the associative array.  Currently it uses about
#  15 to 20 percent of available memory.

        if ( $exclusion_id_count >= 10000000 )
        {
            &exclude_street_ids_from_intersection_file( ) ;
            %yes_exclude_way_or_relation_id = ( ) ;
            $exclusion_id_count = 0 ;
        }


#--------------------------------------------------
#  If the line does not contain an item ID then
#  write the line for possible debugging.

    } else
    {
        print "line not recognized: " . $input_item_id_line . "\n" ;
    }


#--------------------------------------------------
#  Repeat the loop to handle the next line in the
#  file that lists item IDs to exclude.

}


#--------------------------------------------------
#  Exclude any final street IDs.  Also ensure the
#  output file has the correct name.  The correct
#  name cannot be used earlier because the number
#  of cycles through the filtering process can be
#  an odd number or even number.

$output_filename_from_filter = $output_filename_final ;
&exclude_street_ids_from_intersection_file( ) ;


#--------------------------------------------------
#  End of main code.

print "retained " . $retained_line_count . " intersections" . "\n" ;
print "excluded " . $exclusion_line_count . " intersections" . "\n" ;


#--------------------------------------------------
#  Subroutine exclude_street_ids_from_intersection_file
#
#  Read and write the intersection info but filter
#  out the lines that contain a street ID that
#  is to be excluded.

sub exclude_street_ids_from_intersection_file
{


#--------------------------------------------------
#  Indicate how many item IDs are in the list of
#  items to be excluded.

    print "will exclude " . $exclusion_id_count . " item IDs" . "\n" ;


#--------------------------------------------------
#  Open the input and output files for this pass
#  through the data.

#    print "input filename to filter: " . $input_filename_to_filter . "\n" ;
#    print "output filename from filter: " . $output_filename_from_filter . "\n" ;
    open( IN_FILE_FILTER , '<' , $input_filename_to_filter ) ;
    open( OUT_FILE_FILTER , '>' , $output_filename_from_filter ) ;


#--------------------------------------------------
#  Exclude the intersections for which one of the
#  street IDs is in the list of street IDs to
#  exclude.

    while( $input_intersection_line = <IN_FILE_FILTER> )
    {
        chomp( $input_intersection_line ) ;
        if ( $input_intersection_line =~ /([wr][0-9]+) +([wr][0-9]+)/ )
        {
            $first_street_id = $1 ;
            $second_street_id = $2 ;
            if ( ( not( exists( $yes_exclude_way_or_relation_id{ $first_street_id } ) ) ) && ( not( exists( $yes_exclude_way_or_relation_id{ $second_street_id } ) ) ) )
            {
                print OUT_FILE_FILTER $input_intersection_line . "\n" ;
                $retained_line_count ++ ;
            } else
            {
                $exclusion_line_count ++ ;
            }
        }
    }


#--------------------------------------------------
#  Close the input and output files.

    close( IN_FILE_FILTER ) ;
    close( OUT_FILE_FILTER ) ;


#--------------------------------------------------
#  Specify the new input and output filenames for
#  the next pass through the intersection data.

    $input_filename_to_filter = $output_filename_from_filter ;
    if ( $output_filename_from_filter ne $output_filename_alpha )
    {
        $output_filename_from_filter = $output_filename_alpha ;
    } else
    {
        $output_filename_from_filter = $output_filename_beta ;
    }


#--------------------------------------------------
#  End of subroutine 

}


#--------------------------------------------------
#  End of code.
