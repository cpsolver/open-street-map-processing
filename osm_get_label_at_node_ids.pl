#--------------------------------------------------
#       osm_get_label_at_node_ids.pl
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

