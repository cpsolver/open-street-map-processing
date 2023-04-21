#--------------------------------------------------
#       osm_remove_unneeded_nodes_from_way_info.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com
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


