#--------------------------------------------------
#       osm_eliminate_non_intersection_street_joins.pl
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
#  perl osm_eliminate_non_intersection_street_joins.pl


#--------------------------------------------------
#  Gets intersections from the file
#  "output_merged_intersections_and_street_names.txt"
#  and checks street names.  If both street names
#  are the same, the intersection is removed because
#  the node is a join point for two segments of the
#  same street.  If either street name is missing
#  from the supplied region-specific info here,
#  that intersection is removed.


#--------------------------------------------------
#  Sample input test lines.

# 1063_1070 w4973733 w4973735 4255414 4169558
# 1063_1070 w4973733 Street_Name
# 1063_1070 w4973735 Street_Name_Something
# 1063_1070 w4973733 w4998649 4255414 4169558
# 1063_1070 w4973735 w11937047 4255414 4169558
# 1063_1070 w4998649 Street_Name
# 1063_1070 w11937047 Street_Name_Different
# 1059_1010 w148010553 Street_Name_Other
# 1059_1010 w111269061 Street_Name_Two
# 1059_1010 w4982951 w4982993 9601275 7868320
# 1059_1010 w4982951 Some_Other_Name
# 1059_1010 w119374047 Yet_Another
# 1059_1010 w111269061 w119374047 9435372 8502535
# 1059_1010 w111269061 w148010553 9435372 8502535
# 1059_1010 w4973732 w4973734 4255414 4169558
# 1059_1010 w4973732 Maney_Hill_Road
# 1059_1010 w4973734 Maney_Hill_Road
# 1059_1010 w119374047 w148010553 9435372 8502535
# 1059_1010 w311606465 w881130716 9530363 7690581
# 1059_1010 w4606006 w135343990 9444494 7483975
# 1059_1010 w4606006 w135344010 9444494 7483975
# 1059_1020 w4606006 Another_Street
# 1059_1020 w4606006 w135343990 9444494 7483975
# 1059_1020 w4973734 Another_Street_Diffname
# 1059_1020 w4973732 w4973734 4255414 4169558
# 1059_1020 w46066 w1353490 9444494 7483975
# 1059_1020 w4973732 Maney_Hill_Road


#--------------------------------------------------
#  Open the main output file, and a log file that
#  lists information about the intersections that
#  were removed.

$output_filename = 'output_uploadable_street_intersections.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_FILE , '>' , $output_filename ) ;
$output_filename = 'output_log_street_joins.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_LOG_FILE , '>' , $output_filename ) ;


#--------------------------------------------------
#  Open the input file that contains the
#  intersection info and region-specific street
#  name info.

$input_filename = 'temp_merged_sorted_intersections_and_street_names.txt' ;
print "input filename: " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;


#--------------------------------------------------
#  Get the region ID from each line of the input
#  file.

$previous_region_id = "" ;
$storage_line_number = 0 ;
while( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([0-9]+[ _][0-9]+) / )
    {
        $next_region_id = $1 ;
    } else
    {
        if ( $input_line =~ /[^ ]/ )
        {
            print OUT_LOG_FILE "line not recognized: " . $input_line . "\n" ;
        }
        next ;
    }


#--------------------------------------------------
#  If the region ID has changed, process the data
#  from the recent region, then start handling the
#  new region.

    if ( $previous_region_id eq "" )
    {
        $previous_region_id = $next_region_id ;
    }
    if ( $next_region_id ne $previous_region_id )
    {
        &filter_out_joins( ) ;
        $previous_region_id = $next_region_id ;
        $storage_line_number = 0 ;
    }


#--------------------------------------------------
#  Store a street name that is within this region.

    if ( $input_line =~ /^[0-9]+[ _][0-9]+ +([wr][0-9]+) +([^ ]+) *$/ )
    {
        $street_id = $1 ;
        $street_name = $2 ;
        $street_name_for_street_id{ $street_id } = $street_name ;


#--------------------------------------------------
#  Store the intersection lines within this region.

    } elsif ( $input_line =~ /^[0-9]+[ _][0-9]+ +[wr][0-9]+ +[wr][0-9]+ +[0-9]+ +[0-9]+/ )
    {
        $storage_line_number ++ ;
        $line_numbered[ $storage_line_number ] = $input_line ;


#--------------------------------------------------
#  Ignore anything not recognized.

    } else
    {
        print OUT_LOG_FILE "info not recognized: " . $input_line . "\n" ;
        next ;
    }


#--------------------------------------------------
#  Repeat the loop to handle the next input line.

}


#--------------------------------------------------
#  Process the last region.

if ( $storage_line_number > 0 )
{
    &filter_out_joins( ) ;
}


#--------------------------------------------------
#  End of main code.

print OUT_LOG_FILE "removed " . $removal_count_join . " joins from intersections" . "\n" ;
print OUT_LOG_FILE "removed " . $removal_count_missing_name . " intersections with missing names" . "\n" ;
close( OUT_FILE ) ;


#--------------------------------------------------
#  Subroutine filter_out_joins
#
#  Only write the intersection lines in which the
#  two street names are known but do not match.

sub filter_out_joins
{
    $number_of_lines_in_region = $storage_line_number ;
    if ( $number_of_lines_in_region < 1 )
    {
        return ;
    }
    for ( $line_number = 1 ; $line_number <= $number_of_lines_in_region ; $line_number ++ )
    {
        if ( $line_numbered[ $line_number ] =~ /^[0-9]+[ _][0-9]+ +([wr][0-9]+) +([wr][0-9]+) +[ 0-9]+/ )
        {
            $first_street_id = $1 ;
            $second_street_id = $2 ;
            if ( ( exists( $street_name_for_street_id{ $first_street_id } ) ) && ( exists( $street_name_for_street_id{ $second_street_id } ) ) )
            {
                if ( $street_name_for_street_id{ $first_street_id } ne $street_name_for_street_id{ $second_street_id } )
                {
                    print OUT_FILE $line_numbered[ $line_number ] . "\n" ;
                } else
                {
                    print OUT_LOG_FILE $street_name_for_street_id{ $first_street_id } . "  " . $first_street_id . "\n" . $street_name_for_street_id{ $second_street_id } . "  " . $second_street_id . "\n\n" ;
                    $removal_count_join ++ ;
                }
            } else
            {
                if ( not( exists( $street_name_for_street_id{ $first_street_id } ) ) )
                {
                    print OUT_LOG_FILE "missing name for street ID " . $first_street_id . "\n\n" ;
                }
                if ( not( exists( $street_name_for_street_id{ $second_street_id } ) ) )
                {
                    print OUT_LOG_FILE "missing name for street ID " . $second_street_id . "\n\n" ;
                }
                $removal_count_missing_name ++ ;
            }
        }
    }
    %street_name_for_street_id = ( ) ;
    $storage_line_number = 0 ;
}


#--------------------------------------------------
#  End of code.

