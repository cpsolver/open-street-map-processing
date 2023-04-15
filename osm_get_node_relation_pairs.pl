#--------------------------------------------------
#       osm_get_node_relation_pairs.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_node_relation_pairs.pl < input_relation_info.txt > output_node_relation_pairs.txt


#--------------------------------------------------

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /(r[0-9]+) .*links_([nw0-9_]+) / )
    {
        $relation_id = $1 ;
        $links_text = $2 ;
        @list_of_node_ids = split( /_/ , $links_text ) ;
        foreach $node_id ( @list_of_node_ids )
        {
            if ( $node_id =~ /^n[0-9]+$/ )
            {
                print $node_id . " " . $relation_id . "\n" ;
            }
        }
    }
    if ( $input_line =~ /(r[0-9]+) .*label_at_(n[0-9]+) / )
    {
        $relation_id = $1 ;
        $node_id = $2 ;
        if ( $node_id =~ /^n[0-9]+$/ )
        {
            print $node_id . " " . $relation_id . "\n" ;
        }
    }
}

