#--------------------------------------------------
#       osm_get_prefixed_node_and_way_or_relation_pairs.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_prefixed_node_and_way_or_relation_pairs.pl < input_file.txt > output_file.txt


#--------------------------------------------------
#  From either way info or relation info get the
#  node IDs in the "links_" entry or get the
#  "label_at" nodes.  Write each pair of item IDs,
#  which are either a node and way or a node and
#  relation.  Insert at the beginning of each
#  output line the two digits at the end of the
#  node ID.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^[cb]? *(r[0-9]+) .*label_at_(n[0-9]+) / )
    {
        $info_item_id = $1 ;
        $node_id = $2 ;
        if ( $node_id =~ /^n[0-9]*([0-9][0-9])$/ )
        {
            $ending_two_digits = $1 ;
            print $ending_two_digits . " " . $node_id . " " . $info_item_id . "\n" ;
        }


    } elsif ( $input_line =~ /^[cb]? *([wr][0-9]+) +(links_)?([nw0-9_]+)/ )
    {
        $info_item_id = $1 ;
        $list_of_item_ids_as_text = $3 ;
        if ( $item_ids =~ /_/ )
        {
            @list_of_item_ids = split( /_+/ , $list_of_item_ids_as_text ) ;
        } else
        {
            @list_of_item_ids = ( $list_of_item_ids_as_text ) ;
        }
        foreach $possible_node_id ( @list_of_item_ids )
        {
            if ( $possible_node_id =~ /^n[0-9]*([0-9][0-9])$/ )
            {
                $ending_two_digits = $1 ;
                print $ending_two_digits . " " . $possible_node_id . " " . $info_item_id . "\n" ;
            }
        }
    }
}


