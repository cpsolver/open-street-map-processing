#--------------------------------------------------
#       osm_get_prefixed_pairs_from_way_info.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com

#  Usage:
#
#  perl osm_get_prefixed_pairs_from_way_info.pl < output_way_info.txt > output_prefixed_node_way_pairs.txt


#--------------------------------------------------
#  Sample input lines:

# c w1674769 links_n6975507_n1209640318_n6975509_n5257209575_n1593436955_ Reichmanngasse no_label no_alt_name lang_count_0 admin_level_9 boundary_administrative no_is_in

# c w1819359 links_n7456942_n7456963_n7456960_n7456959_n7456957_ Fenzlgasse no_label no_alt_name lang_count_0 admin_level_9 boundary_administrative no_is_in

# b w3987601 links_n20831347_n20831348_n9776783838_n9776783839_n9776783840_n20831349_n20831346_n20831347_ Lake_House_Cafe amenity_cafe www.lakehousecafe.co.uk

# b w4075885 links_n21590968_n21590969_n21590961_n21590960_n21590965_n21590956_n21590954_n21590955_n21590958_n21590959_n21590966_n21590967_n21590968_ Homebase shop_doityourself no_web

# w111927 links_n6867243030_n865858_n4403283011_n5117996687_n6258745156_n1124056388_n5094767028_n5094767027_n865851_n5094767026_n865850_n4318040231_n865849_n8170413026_n8170413021_n6258745139_n1124050539_n1556007964_n8170413020_n73268358_n4917489829_n3856148200_

# w508603 links_n2854184_n5560626635_n3654701364_


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
    $item_ids = "" ;
    if ( $input_line =~ /(w[0-9]+) .*label_at_(n[0-9]+)/ )
    {
        $way_id = $1 ;
        $item_ids = $2 ;
    } elsif ( $input_line =~ /(w[0-9]+) .*links_([_nwr0-9]+)/ )
    {
        $way_id = $1 ;
        $item_ids = $2 ;
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

