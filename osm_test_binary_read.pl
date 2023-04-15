#--------------------------------------------------
#       osm_test_binary_read.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com


$input_filename = 'lats_lons_in_groups/output_packed_lats_lons_in_group_44.bin' ;
open( IN_FILE_BINARY, '<:raw' , $input_filename ) or die $! ;

while( read( IN_FILE_BINARY , $bytes , 18 ) )
{
    $character_string = unpack( "h36" , $bytes ) ;
    print substr( $character_string , 0 , 12 ) . "  " . substr( $character_string , 12 , 12 ) . "  " . substr( $character_string , 24 , 12 ) . "\n" ;
}

