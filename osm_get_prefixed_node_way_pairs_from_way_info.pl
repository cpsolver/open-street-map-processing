#--------------------------------------------------
#       osm_get_prefixed_node_way_pairs_from_way_info.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com

#  Usage:
#
#  perl osm_get_prefixed_node_way_pairs_from_way_info.pl < output_way_info.txt


#--------------------------------------------------
#  Get the node and way pairs.  They are needed to
#  locate this way item.  Ignore a link to a way
#  because that is a complication that is
#  unlikely to be relevant.  Prefix each line with
#  the last two digits of the node ID to allow the
#  list to be sorted on that basis.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ / (w[0-9]+) .*label_at_(n[0-9]+)/ )
    {
        $way_id = $1 ;
        $node_id = $2 ;
        if ( $node_id =~ /^n[0-9]*([0-9][0-9])$/ )
        {
            $ending_two_digits = $1 ;
            print $ending_two_digits . " " . $node_id . " " . $way_id . "\n" ;
        }
    } elsif ( $input_line =~ / (w[0-9]+) .*links_([_nwr0-9]+)/ )
    {
        $way_id = $1 ;
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
            if ( $item_id =~ /^n[0-9]*([0-9][0-9])$/ )
            {
                $ending_two_digits = $1 ;
                print $ending_two_digits . " " . $item_id . " " . $way_id . "\n" ;
            }
        }
    }
}

