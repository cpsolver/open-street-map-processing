#--------------------------------------------------
#       osm_get_node_ids_from_relation_info.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_node_ids_from_relation_info.pl < input_relation_info.txt > output_node_ids_from_relation_info.txt


#--------------------------------------------------

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ / links_([nw0-9_]+) / )
    {
        $links_text = $1 ;
        @list_of_node_ids = split( /_/ , $links_text ) ;
        foreach $node_id ( @list_of_node_ids )
        {
            if ( $node_id =~ /^n[0-9]+$/ )
            {
                print $node_id . "\n" ;
            }
        }
    }
    if ( $input_line =~ / label_at_(n[0-9]+) / )
    {
        $node_id = $1 ;
        if ( $node_id =~ /^n[0-9]+$/ )
        {
            print $node_id . "\n" ;
        }
    }
}

