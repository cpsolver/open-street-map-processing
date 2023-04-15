#--------------------------------------------------
#       osm_get_way_ids_from_relation_info.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_way_ids_from_relation_info.pl < input_relation_info.txt > output_way_ids_from_relation_info.txt


#--------------------------------------------------

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ / links_([nw0-9_]+) / )
    {
        $links_text = $1 ;
        @list_of_way_ids = split( /_/ , $links_text ) ;
        foreach $way_id ( @list_of_way_ids )
        {
            if ( $way_id =~ /^w[0-9]+/ )
            {
                print $way_id . "\n" ;
            }
        }
    }
}

