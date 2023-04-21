#--------------------------------------------------
#       osm_get_just_needed_nodes_and_ways_from_relation_info.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com
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
#  Usage for city data:
#
#  perl osm_get_just_needed_nodes_and_ways_from_relation_info.pl < output_city_relation_info.txt > output_city_relation_info_without_extra_ways.txt
#
#  Usage for business data:
#
#  perl osm_get_just_needed_nodes_and_ways_from_relation_info.pl < output_business_relation_info.txt > output_business_relation_info_without_extra_ways.txt


#--------------------------------------------------
#  Sample input lines:

#  c r186761 links_w931824059_w931824057_w38420840_w643653558_w932655373_w932655374_w935195274_w935195276_w935195278_w284635414_w935195282_w935195283_w643653559_w643653560_w932572286_w932572287_ Bend label_at_n150949235 no_alt_name lang_count_0 admin_level_8 border_type_city boundary_administrative no_is_in

#  c r4569 links_n1395162377_w202164033_w949200140_w87267396_w523670185_w168704636_w168704618_w168833167_w88734972_w88736728_w168833169_w160221480_w371873106_w371873105_w784901516_w371874263_w690067607_w745779454_w371870255_w168833166_w745779451_w87267339_ Knokke-Heist no_label no_alt_name lang_count_3 admin_level_8 boundary_administrative population_33556 no_is_in

#  b r8197399 links_w586388154_w586388153_ Happy_Hot_Pizz&#233;ria amenity_restaurant www.happyhotpizza.hu

#  b r9359740 links_n5144998533_w326129715_ Taste_of_India amenity_restaurant no_web

#  b r9359805 links_w326129714_n5144998534_ Amy&#39;s_Place amenity_restaurant no_web

#  c r4557 links_n240080296_n240114685_ Mosnang no_label no_alt_name lang_count_0 place_village population_2829 no_is_in


#--------------------------------------------------
#  Open the output files for the node and relation
#  pairs and the way and relation pairs.

$output_filename = 'output_way_relation_pairs.txt' ;
open( OUT_WAY_REL , '>' , $output_filename ) or die $! ;
$output_filename = 'output_node_relation_pairs.txt' ;
open( OUT_NODE_REL , '>' , $output_filename ) or die $! ;


#--------------------------------------------------
#  If there is a "label_at_n..." entry, or
#  one (or more) node ID in the list of links,
#  remove all the way IDs -- because the node(s)
#  will be used as the center location.  For the
#  remaining nodes and ways, write the node and
#  relation pairs and the way and relation
#  pairs.  They are needed to locate this
#  relation item.  Ignore a link to a relation
#  because that is a complication that is
#  unlikely to be relevant.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^ *$/ )
    {
        next ;
    }
    $output_line = $input_line ;
    if ( $input_line =~ /^(.+) +links_[^ ]* +(.*label_at_(n[0-9]+) +.+)$/ )
    {
        $prefix_info = $1 ;
        $suffix_info = $2 ;
        $node_id = $3 ;
        $output_line = $prefix_info . " " . $suffix_info ;
        $output_line =~ s/ no_label / / ;
    } elsif ( $input_line =~ /^(.+) links_([^ ]+) (.+)$/ )
    {
        $prefix_info = $1 ;
        $link_ids = $2 ;
        $suffix_info = $3 ;
        $link_ids =~ s/(r[0-9]+_)+//g ;
        if ( $link_ids =~ /n.+n/ )
        {
            $link_ids =~ s/(w[0-9]+_)+//g ;
            $output_line = $prefix_info . " links_" . $link_ids . " " . $suffix_info ;
        } elsif ( $link_ids =~ /n/ )
        {
            $link_ids =~ s/(w[0-9]+_)+//g ;
            $link_ids =~ s/_+//g ;
            $output_line = $prefix_info . " label_at_" . $link_ids . " " . $suffix_info ;
            $output_line =~ s/ no_label / / ;
        } else
        {
            $output_line = $prefix_info . " links_" . $link_ids . " " . $suffix_info ;
        }
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
    } elsif ( $output_line =~ / (r[0-9]+) .*links_([_nw0-9]+)/ )
    {
        $relation_id = $1 ;
        $item_ids = $2 ;
        if ( $item_ids =~ /_/ )
        {
            @list_of_item_ids = split( /_+/ , $item_ids ) ;
        } else
        {
            @list_of_item_ids = ( $item_ids ) ;
        }
        foreach $item_id ( @list_of_item_ids )
        {
            if ( $item_id =~ /n[0-9]+/ )
            {
                print OUT_NODE_REL $item_id . " " . $relation_id . "\n" ;
            } elsif ( $item_id =~ /w[0-9]+/ )
            {
                print OUT_WAY_REL $item_id . " " . $relation_id . "\n" ;
            }
        }
    }
}


