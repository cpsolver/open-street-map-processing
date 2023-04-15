#--------------------------------------------------
#       osm_test_binary_write.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com


$full = "123456789012345678901234567890123456" ;
$output_filename = 'test_binary.bin' ;
open( OUT_FILE, '>' , $output_filename ) or die $! ;

for ( $group_counter = 1 ; $group_counter <= 999 ; $group_counter ++ )
{
    print OUT_FILE pack( "h36" , $full ) ;
}

