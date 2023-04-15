#--------------------------------------------------
#       osm_split_business_free_listing_versus_promo.pl
#--------------------------------------------------

#  (c) Copyright 2018-2023 by Richard Fobes at SolutionsCreative.com


#  Usage in Linux environment:
#  perl osm_split_business_free_listing_versus_promo.pl > output_log_osm_handle_business_info.txt

#  Sample input line:
#  b 10454676590 08772863862 w291415817 Annie_Bloom&#39;s_Books bookstore www.annieblooms.com


#--------------------------------------------------
#  Specify the output filenames.

$path_to_OSM_files = "" ;
$output_filename_free_listing_business_info = $path_to_OSM_files . 'output_businesses_free_listing.txt' ;
$output_filename_promo_business_info = $path_to_OSM_files . 'output_businesses_promo_type.txt' ;
$output_filename_unrecognized_business_info = $path_to_OSM_files . 'output_businesses_unrecognized.txt' ;
open ( OUTFREE , ">" . $output_filename_free_listing_business_info ) ;
open ( OUTPROMO , ">" . $output_filename_promo_business_info ) ;
open ( OUTUNREC , ">" . $output_filename_unrecognized_business_info ) ;


#--------------------------------------------------
#  Specify the free-listing business types.

$yes_if_free_listing_business_type{ "restaurant" } = "yes" ;
$yes_if_free_listing_business_type{ "cafe" } = "yes" ;
$yes_if_free_listing_business_type{ "deli" } = "yes" ;
$yes_if_free_listing_business_type{ "bakery" } = "yes" ;
$yes_if_free_listing_business_type{ "biergarten" } = "yes" ;
$yes_if_free_listing_business_type{ "pastry" } = "yes" ;
$yes_if_free_listing_business_type{ "tea_shop" } = "yes" ;

#  Include independent alternatives to Amazon, Starbucks, Home Depot

$yes_if_free_listing_business_type{ "bookstore" } = "yes" ;
$yes_if_free_listing_business_type{ "hardware" } = "yes" ;
$yes_if_free_listing_business_type{ "doityourself" } = "yes" ;
$yes_if_free_listing_business_type{ "coffee_shop" } = "yes" ;


#--------------------------------------------------
#  Main loop.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^b [0-9]+ [0-9]+ [nwr][0-9]+ [^ ]+ ([^ ]+)/ )
    {
        $business_type = $1 ;
        if ( exists( $yes_if_free_listing_business_type{ $business_type } ) )
        {
            print OUTFREE $input_line . "\n" ;
        } else
        {
            print OUTPROMO $input_line . "\n" ;
        }
    } else
    {
        print OUTUNREC $input_line . "\n" ;
    }
}
