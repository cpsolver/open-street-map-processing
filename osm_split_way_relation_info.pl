#--------------------------------------------------
#       osm_split_way_relation_info.pl
#--------------------------------------------------

#  (c) Copyright 2014-2016 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:
#  Create needed folder(s) on internal hard drive.
#  (Done 2015-Oct on external hard drive for street way info, but only needed 12GB.)
#  Then edit this script to specify that path.
#  Then in terminal run:
#  perl osm_split_way_relation_info.pl < output_..._way_info.txt >> output_log_osm_split_way_relation_info.txt


#--------------------------------------------------
#  Specify the output filenames and path.

$slash_or_backslash = "\\" ;

$path_only_for_output_info = "F:\\CitiesBusinessesPostalCodesCongressionalDistricts\\get_osm_and_postal\\" ;

$filename_prefix_for_relation_info = 'output_way_info_from_relations' ;

$folder_name_for_node_info = "nodes" ;

$filename_prefix_for_way_info = 'output_ways_with_node_suffix_' ;

$filename_prefix_for_linkage_info = 'output_linkages_with_node_suffix_' ;


#--------------------------------------------------
#  Reminder about ID numbers:
#      n123 = node ID
#      w123 = way ID
#      r123 = relation ID


#--------------------------------------------------
#  Reminder about data_type:
#      l = linkage between way and its associated nodes
#      b = business data
#      c = city data
#      s = street data


#--------------------------------------------------
#  Read each line in the file.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;

  print "** " . $input_line . "\n" ;


#--------------------------------------------------
#  Handle the splitting of way and relation info.
#
#  Sample input lines:
#
#      s w4320291 Autoroute_Ville_Marie_Est highway_motorway  no_alt_name linked_n16874364_n26232302_
#
#      s w12721606 Roundtree_Crescent highway_residential  alt_name_Avenue_de_Roundtree_Crescent linked_n116258984_n116259366_n116259368_n116259369_n116259370_n116258986_
#
#      b w4805648 Pavilion_Restaurant no_web amenity_restaurant links_n30843051_n30843046_n30843047_n30843048_n30843049_n30843050_n30843051_
#
#      b r4105607 Der_B&#228;cker_Lampe shop_bakery amenity_cafe  no_web links_w173378981_w307420461_w307420499_
#
#      c w1234 ...
#
#      c r1234 ...

    $way_or_relation_id = "" ;
    if ( $input_line =~ /^([sbcl]) +([wr][0-9]+) +([^ ].*)/ )
    {
        $data_type = $1 ;
        $way_or_relation_id = $2 ;
        $remainder_of_line = $3 ;
    }
    if ( $way_or_relation_id ne "" )
    {
        @list_of_item_names = ( $item_name ) ;
        if ( $remainder_of_line =~ /^(.*)alt_name_([^ ]+)(.*)$/ )
        {
            $prefix = $1 ;
            $alternate_item_name = $2 ;
            $suffix = $3 ;
            $remainder_of_line = $prefix . " " . $suffix ;
            push( @list_of_item_names , $alternate_item_name ) ;
        }
        if ( $remainder_of_line =~ /^(.*)links_([^ ]+)_(.*)$/ )
        {
            $prefix = $1 ;
            $list_of_linked_nodes_or_ways = $2 ;
            $suffix = $3 ;
            $remainder_of_line = $prefix . " " . $suffix ;
            @list_of_node_or_way_ids = split( /_/ , $list_of_linked_nodes_or_ways ) ;
        }
        foreach $item_name ( @list_of_item_names )
        {
            foreach $node_or_way_id ( @list_of_node_or_way_ids )
            {
                $output_line = $data_type . " " . $node_or_way_id . " " . $way_or_relation_id . " " . $remainder_of_line ;
                $output_line =~ s/  +/ /g ;
                $output_line =~ s/ +$// ;
                if ( $data_type eq "l" )
                {
                    $category_for_linkage_number = substr( $node_or_way_id , -3 , 3 ) ;
                    $output_lines_for_linkage_category{ $category_for_linkage_number } .= $output_line . "\n" ;
                    $count_lines_linkage_info_ready_to_write ++ ;
                } elsif ( substr( $node_or_way_id , 0 , 1 ) eq "n" )
                {
                    $category_for_node_number = substr( $node_or_way_id , -3 , 3 ) ;

#  if needed for debugging, uncomment:
# if ( $category_for_node_number ne "174" )
# {
#   next ;
# }

                    $output_lines_for_node_category{ $category_for_node_number } .= $output_line . "\n" ;
                    $count_lines_node_info_ready_to_write ++ ;
                } elsif ( substr( $node_or_way_id , 0 , 1 ) eq "w" )
                {
                    $output_lines_for_way_info .= $output_line . "\n" ;
                    $count_lines_way_info_ready_to_write ++ ;
                }
                if ( $count_lines_node_info_ready_to_write > 100000 )
                {
                    &write_node_info( ) ;
                    %output_lines_for_node_category = ( ) ;
                    $count_lines_node_info_ready_to_write = 0 ;
                }
                if ( $count_lines_way_info_ready_to_write > 100000 )
                {
                    &write_way_info( ) ;
                    %output_lines_for_way_category = ( ) ;
                    $count_lines_way_info_ready_to_write = 0 ;
                }
                if ( $count_lines_linkage_info_ready_to_write > 100000 )
                {
                    &write_linkage_info( ) ;
                    %output_lines_for_linkage_category = ( ) ;
                    $count_lines_linkage_info_ready_to_write = 0 ;
                }
            }
        }
    }


#--------------------------------------------------
#  Repeat the loop for the next line in the file.

}


#--------------------------------------------------
#  Write any lines that remain in the buffer.

&write_node_info( ) ;
&write_way_info( ) ;
&write_linkage_info( ) ;


#--------------------------------------------------
#  All done.


#--------------------------------------------------
#--------------------------------------------------
#  Functions that write buffered lines.

sub write_node_info
{
    foreach $category_for_node_number ( keys( %output_lines_for_node_category ) )
    {
        open OUTBUF , ">>" . $path_only_for_output_info . $folder_name_for_node_info . $slash_or_backslash . $filename_prefix_for_way_info . $category_for_node_number . '.txt' ;
        print OUTBUF $output_lines_for_node_category{ $category_for_node_number } ;
        close OUTBUF ;
    }
}

sub write_way_info
{
    open OUTBUF , ">>" . $path_only_for_output_info . $filename_prefix_for_relation_info . '.txt' ;
    print OUTBUF $output_lines_for_way_info ;
    close OUTBUF ;
}

sub write_linkage_info
{
    foreach $category_for_linkage_number ( keys( %output_lines_for_linkage_category ) )
    {
        open OUTBUF , ">>" . $path_only_for_output_info . $folder_name_for_node_info . $slash_or_backslash . $filename_prefix_for_linkage_info . $category_for_linkage_number . '.txt' ;
        print OUTBUF $output_lines_for_linkage_category{ $category_for_linkage_number } ;
        close OUTBUF ;
    }
}
