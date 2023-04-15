#--------------------------------------------------
#       osm_remove_unneeded_ways_from_relation_info.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com

#  Usage for city data:
#
#  perl osm_remove_unneeded_ways_from_relation_info.pl < output_city_relation_info.txt > output_city_relation_info_without_extra_ways.txt
#
#  Usage for business data:
#
#  perl osm_remove_unneeded_ways_from_relation_info.pl < output_business_relation_info.txt > output_business_relation_info_without_extra_ways.txt


#--------------------------------------------------
#  Sample input lines:

#  c r186761 links_w931824059_w931824057_w38420840_w643653558_w932655373_w932655374_w935195274_w935195276_w935195278_w284635414_w935195282_w935195283_w643653559_w643653560_w932572286_w932572287_ Bend label_at_n150949235 no_alt_name lang_count_0 admin_level_8 border_type_city boundary_administrative no_is_in

#  c r4569 links_n1395162377_w202164033_w949200140_w87267396_w523670185_w168704636_w168704618_w168833167_w88734972_w88736728_w168833169_w160221480_w371873106_w371873105_w784901516_w371874263_w690067607_w745779454_w371870255_w168833166_w745779451_w87267339_ Knokke-Heist no_label no_alt_name lang_count_3 admin_level_8 boundary_administrative population_33556 no_is_in

#  b r8197399 links_w586388154_w586388153_ Happy_Hot_Pizz&#233;ria amenity_restaurant www.happyhotpizza.hu

#  b r9359740 links_n5144998533_w326129715_ Taste_of_India amenity_restaurant no_web

#  b r9359805 links_w326129714_n5144998534_ Amy&#39;s_Place amenity_restaurant no_web


#--------------------------------------------------
#  Open the output file for the node and relation
#  pairs.

$output_filename = 'output_node_relation_pairs.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_NODE_REL , '>' , $output_filename ) or die $! ;


#--------------------------------------------------
#  If there is a "label_at_n..." entry, or
#  one node ID in the list of links, remove all the
#  way IDs -- because that node location will be
#  used as the center.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^ *$/ )
    {
        next ;
    } elsif ( $input_line =~ /^(.+) +links_[^ ]* +(.*label_at_(n[0-9]+) +.+)$/ )
    {
        $output_line = $1 . " " . $2 ;
        $output_line =~ s/ no_label / / ;
    } elsif ( $input_line =~ /^(.+) +links_[w0-9_]*(n[0-9]+)[w0-9_]* +(.+)$/ )
    {
        $output_line = $1 . " " . "label_at_" . $2 . " " . $3 ;
        $output_line =~ s/ no_label / / ;
    } else
    {
        $output_line = $input_line ;
    }
    print $output_line . "\n" ;
    if ( $output_line =~ / (r[0-9]+) .*label_at_(n[0-9]+)/ )
    {
        $relation_id = $1 ;
        $node_id = $2 ;
        print OUT_NODE_REL $node_id . " " . $relation_id . "\n" ;
    }
}


