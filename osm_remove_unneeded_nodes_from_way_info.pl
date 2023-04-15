#--------------------------------------------------
#       osm_remove_unneeded_nodes_from_way_info.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com

#  Usage:
#
#  perl osm_remove_unneeded_nodes_from_way_info.pl < output_way_info.txt > output_way_info_without_extra_nodes.txt


#--------------------------------------------------
#  Open the output file for the node and way pairs.

$output_filename = 'output_node_way_pairs.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_NODE_WAY , '>' , $output_filename ) or die $! ;


#--------------------------------------------------
#  If there is a "label_at_n..." entry, remove all
#  the other node IDs -- because that node location
#  will be used as the center.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^ *$/ )
    {
        next ;
    } elsif ( $input_line =~ /^(.+) +links_[^ ]* +(.*label_at_(n[0-9]+) +.+)$/ )
    {
        $prefix = $1 ;
        $suffix = $2 ;
        $node_id = $3 ;
        $output_line = $prefix . " " . $suffix ;
        $output_line =~ s/ no_label / / ;
        print $output_line . "\n" ;
        if ( $prefix =~ /(w[0-9]+)/ )
        {
            $way_id = $1 ;
            print OUT_NODE_WAY $node_id . " " . $way_id . "\n" ;
        }
    } else
    {
        print $input_line . "\n" ;
    }
}


