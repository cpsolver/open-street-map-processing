#--------------------------------------------------
#       osm_get_midpoints_for_way_info.pl
#--------------------------------------------------

#  (c) Copyright 2014-2022 by Richard Fobes at NewsHereNow.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_midpoints_for_way_info.pl


#---------------------------------------------------
#  Get the node IDs with latitudes and longitudes.

#  Sample input line:
#      n10781757 10521372894 09990054007

$filename_with_lats_lons = "output_lats_lons_for_listed_nodes.txt" ;
open( INFILE , "<" . $filename_with_lats_lons ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /(n[0-9]+) +([0-9]+) +([0-9]+)/ )
    {
        $node_id = $1 ;
        $lat = $2 . "" ;
        $lon = $3 . "" ;
        $latitude_at_node{ $node_id } = $lat ;
        $longitude_at_node{ $node_id } = $lon ;
    }
}
close( INFILE ) ;


#--------------------------------------------------
#  Open the output files.

$path_and_filename_for_output = "output_biz_or_city_info_ready_to_split.txt" ;
open OUTFILE , ">" . $path_and_filename_for_output ;

$path_and_filename_for_output_skipped = "output_biz_or_city_info_skipped.txt" ;
open OUTSKIP , ">" . $path_and_filename_for_output_skipped ;


#--------------------------------------------------
#  Read each line of biz or city info.
#  Both node (kept as-is) and way versions are handled.

#  Sample input lines:

#      b w291415817 links_n2630649886_n2948840766_n2948840750_n2948840752_n2948840757_n2948840777_n2630649886_ Annie_Bloom&#39;s_Books shop_books www.annieblooms.com

#      c w564576390 links_n5439266362_n5439266367_n5439266378_n5439266381_n5439266391_n5439266397_n5439266631_n5439266621_n5439266420_n5439266396_n5439266362_ Kejaksaan_Tinggi_Jawa_Tengah no_label no_alt_name lang_count_0 admin_level_4 no_is_in

$filename_with_way_info = "output_biz_or_city_filtered_all.txt" ;

open( INFILE , "<" . $filename_with_way_info ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    $data_type = "" ;
    $link_info = "" ;
    if ( $input_line =~ /^([bc]) +(w[0-9]+) +links_([^ ]+) +([^ ].+)*$/ )
    {
        $data_type = $1 ;
        $way_or_relation_id = $2 ;
        $link_info = $3 ;
        $remainder_of_line = $4 ;
        $input_line = '' ;
    }



#--------------------------------------------------
#  Determine the maximum and minimum latitude and
#  longitude based on all the node-specific locations.

    $max_latitude = -1 ;
    $min_latitude = 999999999999 ;
    $max_longitude = -1 ;
    $min_longitude = 999999999999 ;
    if ( $link_info ne "" )
    {
        $link_info =~ s/_+/ /g ;
        $link_info =~ s/^ // ;
        $link_info =~ s/ $// ;
        @list_of_node_ids = split( / / , $link_info ) ;
        foreach $node_id ( @list_of_node_ids )
        {
            if ( ( exists( $latitude_at_node{ $node_id } ) ) && ( exists( $latitude_at_node{ $node_id } ) ) )
            {
                $latitude = $latitude_at_node{ $node_id } ;
                $longitude = $longitude_at_node{ $node_id } ;
#                print OUTFILE $node_id . " " . $latitude . " " . $longitude . "\n" ;
                if ( $latitude > $max_latitude )
                {
                    $max_latitude = $latitude ;
                }
                if ( $latitude < $min_latitude )
                {
                    $min_latitude = $latitude ;
                }
                if ( $longitude > $max_longitude )
                {
                    $max_longitude = $longitude ;
                }
                if ( $longitude < $min_longitude )
                {
                    $min_longitude = $longitude ;
                }
            }
        }
    }


#--------------------------------------------------
#  Calculate the middle point of each item, and then
#  write the result along with the associated info.
#  If the line did not contain any links (between
#  a way and its nodes), write it as-is.

#  Output must match node version of data, example:
#      b 10508875000 09983816599 n271078 Acres_Down_Farm shop_tea no_web
#      b 10549714751 09983914219 n11150422 Fat_Buddha_Asian_Bar_&#38;_Kitchen amenity_restaurant www.fatbuddhanewcastle.com/Fat_Buddha_Newcastle/Welcome.html

    if ( ( $max_latitude >= $min_latitude ) && ( $max_longitude >= $min_longitude ) )
    {
        $latitude_as_text = sprintf( "%011d" , int( ( $max_latitude + $min_latitude ) / 2 ) ) ;
        $longitude_as_text = sprintf( "%011d" , int( ( $max_longitude + $min_longitude ) / 2 ) ) ;
        print OUTFILE $data_type . " " . $latitude_as_text . " " . $longitude_as_text . " " . $way_or_relation_id . " " . $remainder_of_line . "\n" ;
    }
    if ( $input_line ne '' )
    {
        if ( $input_line =~ / links_/ )
        {
            print OUTSKIP $input_line . "\n" ;
        } else
        {
            print OUTFILE $input_line . "\n" ;
        }
    }


#--------------------------------------------------
#  Repeat loop for next way or relation.

}
