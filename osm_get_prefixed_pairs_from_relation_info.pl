#--------------------------------------------------
#       osm_get_prefixed_pairs_from_relation_info.pl
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


#--------------------------------------------------
#  Usage:

#  perl osm_get_prefixed_pairs_from_relation_info.pl < input_file.txt > output_file.txt


#--------------------------------------------------
#  From relation info get the node IDs in the
#  "links_" entry or get the "label_at" nodes.
#  Write each pair of item IDs, which are either
#  a node and way or a node and relation.  Insert
#  at the beginning of each output line the two
#  digits at the end of the node ID.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    $item_ids = "" ;
    if ( $input_line =~ /(r[0-9]+) .*label_at_(n[0-9]+)/ )
    {
        $way_id = $1 ;
        $item_ids = $2 ;
    } elsif ( $input_line =~ /(r[0-9]+) +(links_)?([nwr0-9_]+)/ )
    {
        $way_id = $1 ;
        $item_ids = $3 ;
    }
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


