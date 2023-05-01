#--------------------------------------------------
#       osm_prepare_street_info_for_sorting.pl
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
#  perl osm_prepare_street_info_for_sorting.pl


#--------------------------------------------------
#  Note:
#  The output lines include a second word of "1" or
#  "2" or "3" etc. after the street ID number so
#  that when all the files are sorted and merged
#  they will be in the sequence needed.


#--------------------------------------------------
#  Specify Linux path style.

$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Copy the relation ID numbers and their street
#  names to a file that will be sorted by relation
#  ID number.
#
#  Sample input line:
#  s r2197 links_w8584816_w58793897_w170869257_w58793901_w215102514_w215102515_w215102513_w215102516_w215102512_w895507581_ Winchester_Road route_road  no_alt_name

$output_filename = 'output_sortable_relation_ids_and_names.txt' ;
open( OUT_FILE , '>' , $output_filename ) ;
$input_filename = 'output_street_relation_info_tagged_as_street.txt' ;
print "reading file " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;
while( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /s +r([0-9]+) +links_[^ ]* +([^ ]+)/ )
    {
        $relation_id = $1 ;
        $street_name = $2 ;
        if ( $street_name !~ /\?\?/ )
        {
            print OUT_FILE "r" . $relation_id . " 1 " . $street_name . "\n" ;
        }
    }
}
close( IN_FILE ) ;
close( OUT_FILE ) ;
print "created file " . $output_filename . "\n" ;


#--------------------------------------------------
#  Copy the way ID numbers and street names to a
#  file that will be sorted by way ID number.
#
#  Sample input line:
#  s w41 links_n200541_n2715159905_n200575_n180180789_n200576_ Rowan_Road highway_residential  no_alt_name

$output_filename = 'output_sortable_way_ids_and_names.txt' ;
open( OUT_FILE , '>' , $output_filename ) ;
$input_filename = 'output_street_way_info_tagged_as_street.txt' ;
print "reading file " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;
while( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /s +w([0-9]+) +links_[^ ]* +([^ ]+)/ )
    {
        $way_id = $1 ;
        $street_name = $2 ;
        if ( $street_name !~ /\?\?/ )
        {
            print OUT_FILE "w" . $way_id . " 2 " . $street_name . "\n" ;
        }
    }
}
close( IN_FILE ) ;
close( OUT_FILE ) ;
print "created file " . $output_filename . "\n" ;


#--------------------------------------------------
#  Copy the street ID numbers and region ID numbers
#  -- which look like "1063_1010" -- to a file that
#  will be sorted by street ID number.
#
#  Sample input line:
#  1063_1010 w4973733 w4973735 4255414 4169558
#
#  Note:  Node n386400 is an intersection with
#  four way IDs, but only two street names are
#  involved.  The four street ways join at that
#  node.  There are likely to be many cases like
#  this.

$output_filename = 'output_sortable_street_ids_and_region_ids.txt' ;
open( OUT_FILE , '>' , $output_filename ) ;
$input_filename = 'output_street_intersections_after_exclusions.txt' ;
print "reading file " . $input_filename . "\n" ;
open( IN_FILE , '<' , $input_filename ) ;
while( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /([0-9]+_[0-9]+) +([^ ].+[^ ]) +[0-9]+ +[0-9]+/ )
    {
        $region_id = $1 ;
        $list_of_street_ids_as_text = $2 ;
        @list_of_street_ids = split( / +/ , $list_of_street_ids_as_text ) ;
        foreach $street_id ( @list_of_street_ids )
        {
            if ( $street_id =~ /r([0-9]+)/ )
            {
                $relation_id = $1 ;
                print OUT_FILE "r" . $relation_id . " 3 " . $region_id . "\n" ;
            } elsif ( $street_id =~ /w([0-9]+)/ )
            {
                $way_id = $1 ;
                print OUT_FILE "w" . $way_id . " 4 " . $region_id . "\n" ;
            }
        }
    }
}
close( IN_FILE ) ;
close( OUT_FILE ) ;
print "created file " . $output_filename . "\n" ;


#--------------------------------------------------
#  All done.

