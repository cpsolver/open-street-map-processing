#--------------------------------------------------
#       osm_get_label_at_node_ids.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_label_at_node_ids.pl < input_file.txt > output_file.txt


#--------------------------------------------------


while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ / label_at_(n[0-9]+)/ )
    {
        $node_id = $1 ;
        print $node_id . "\n" ;
    }
}

