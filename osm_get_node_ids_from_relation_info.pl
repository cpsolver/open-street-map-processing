#--------------------------------------------------
#       osm_get_node_ids_from_relation_info.pl
#--------------------------------------------------

#  (c) Copyright 2022-2023 by Richard Fobes at SolutionsCreative.com
#  Permission to copy and use and modify this
#  software is hereby given to individuals and to
#  businesses with ten or fewer employees if this
#  copyright notice is included in all copies
#  and modified copies.
#  All other rights are reserved.
#  Businesses with more than ten employees are
#  encouraged to contract with small businesses
#  to supply the service of running this software
#  if they also arrange to make donations to
#  support the Open Street Map project.


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

