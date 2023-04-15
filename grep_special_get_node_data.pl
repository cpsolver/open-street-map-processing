#--------------------------------------------------
#       grep_special_get_node_data.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /<node / )
    {
        print $input_line . "\n" ;
        $node_counter ++ ;
    }
    if ( $node_counter > 9999999 )
    {
        exit ;
    }
}

