#--------------------------------------------------
#       osm_get_intersections_and_related_streets.pl
#--------------------------------------------------

#  (c) Copyright 2014-2015 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:
#  Create needed output folders intersections_by_region
#  and street_names_by_region,
#  then edit this script for input and output paths,
#  then in terminal run:
#  perl osm_get_intersections_and_related_streets.pl
#  Do not specify output log file so that progress is
#  monitored in the terminal window.


#--------------------------------------------------
#  Specify the INPUT filename prefixes.
#  If there are any changes in the filename prefix,
#  also change the regular expression below.

$directory_street_nodes = "/home/aw/FilesNoArchive/OpenStreetMapData/street_nodes/" ;
$directory_street_ways = "/home/aw/FilesNoArchive/OpenStreetMapData/street_ways/" ;
$file_name_prefix_for_node_info = $directory_street_nodes . "output_street_nodes_in_category_" ;
$file_name_prefix_for_way_info = $directory_street_ways . "output_ways_with_node_suffix_" ;


#--------------------------------------------------
#  Specify the OUTPUT filenames.
#
#  Use internal, not external, drive because
#  files are not big and appending to lots of files
#  is very, very slow using an external drive.

$file_name_prefix_for_intersections = "/media/D_drive/OpenStreetMapData/intersections_by_region/output_intersections_in_region_" ;
$file_name_prefix_for_street_names = "/media/D_drive/OpenStreetMapData/street_names_by_region/output_street_names_in_region_" ;


#--------------------------------------------------
#  Initialization.

@list_first_and_second = ( "first" , "second" ) ;


#---------------------------------------------------
#  Create the list of node categories that need to be
#  handled.
#  If there are any changes in the filename here,
#  also change the related assignments above.
#
#  Just use the categories based on the street nodes,
#  which allows testing with a subset of street nodes.

if ( opendir( READ_DIR , $directory_street_nodes ) )
{
    while ( defined( $file_name = readdir( READ_DIR ) ) )
    {
        if ( $file_name =~ /^output_street_nodes_in_category_([0-9]+)\.txt$/i )
        {
            $node_category = $1 ;
            $list_of_node_categories{ $node_category } = "y" ;
        }
    }
    closedir( READ_DIR ) ;
}


#  if needed for testing:
# %list_of_node_categories = ( ) ;
# $list_of_node_categories{ "579" } = "y" ;
# $list_of_node_categories{ "580" } = "y" ;



#--------------------------------------------------
#  Begin a loop that handles one node category.

$node_category_count = 1 ;
foreach $node_category ( sort( keys( %list_of_node_categories ) ) )
{
    print "node category count " . $node_category_count . " name " . $node_category . "\n" ;
    $node_category_count ++ ;


#--------------------------------------------------
#  Clear the storage areas (from the prior node category).

    $available_storage_position = 1 ;
    %storage_position_for_node_id = ( ) ;
    %already_wrote_intersection = ( ) ;
    %already_wrote_way_id = ( ) ;
    @lat_lon_location_at_storage_position = ( ) ;
    @way_ids_at_storage_position = ( ) ;
    @street_names_at_storage_position = ( ) ;
#    un-comment next line, and other related lines, if need to view node ID for debugging a specific intersection:
#    @node_at_storage_position = ( ) ;


#--------------------------------------------------
#  Read each line of NODE info (within this node
#  category), assign a storage position pointer
#  for it, and store the associated location
#  at that position.

    open( IN_NODE , "<" . $file_name_prefix_for_node_info . $node_category . '.txt' ) ;
    while( $input_line = <IN_NODE> )
    {
        chomp( $input_line ) ;
        if ( $input_line =~ /^(n[0-9]+) ([0-9]+ [0-9]+)/ )
        {
            $node_id = $1 ;
            $lat_lon_location = $2 ;
            $storage_position = $available_storage_position ;
            $available_storage_position ++ ;
            $storage_position_for_node_id{ $node_id } = $storage_position ;
            $lat_lon_location_at_storage_position[ $storage_position ] = $lat_lon_location ;
#            un-comment next line, and other related lines, if need to view node ID for debugging a specific intersection:
#            $node_at_storage_position[ $storage_position ] = $node_id ;
        }
    }
    close( IN_NODE ) ;


#--------------------------------------------------
#  Read each line of WAY info (within this node
#  category), and store the associated way ID
#  and street name, using the same storage position
#  number at which the lat_lon_location info is stored.
#
#  Sample:
#      n203953259 w4320462 Autoroute_Ville-Marie_Ouest

    open( INWAY , "<" . $file_name_prefix_for_way_info . $node_category . '.txt' ) ;
    while( $input_line = <INWAY> )
    {
        chomp( $input_line ) ;
        if ( $input_line =~ /^(n[0-9]+) ([wr][0-9]+) ([^ ]+)/ )
        {
            $node_id = $1 ;
            $way_id = $2 ;
            $street_name = $3 ;
            if ( exists( $storage_position_for_node_id{ $node_id } ) )
            {
                $storage_position = $storage_position_for_node_id{ $node_id } ;
                $way_ids_at_storage_position[ $storage_position ] .= $way_id . " " ;
                $street_names_at_storage_position[ $storage_position ] .= $street_name . " " ;
            }
        }
    }
    close( INWAY ) ;


#--------------------------------------------------
#  Identify nodes at which there is more than one
#  way ID number, because these are intersections.
#
#  At this point the associative array -- that
#  associates node ID text with a storage position
#  number -- is no longer needed.  It has served
#  its purpose of bringing together info at the
#  same storage position.  Now it is faster to
#  loop through the storage positions as a counter.

    for ( $storage_position = 1 ; $storage_position < $available_storage_position ; $storage_position ++ )
    {
        $way_ids = $way_ids_at_storage_position[ $storage_position ] ;
        $way_ids =~ s/ $// ;
        if ( $way_ids =~ / / )
        {
            @list_of_way_ids = split( / / , $way_ids ) ;
            $lat_lon_location = $lat_lon_location_at_storage_position[ $storage_position ] ;
            $street_names = $street_names_at_storage_position[ $storage_position ] ;
            $street_names =~ s/ $// ;
            @list_of_street_names = split( / / , $street_names ) ;
            for ( $which_way_first = 0 ; $which_way_first < $#list_of_way_ids ; $which_way_first ++ )
            {
                $way_id_first = $list_of_way_ids[ $which_way_first ] ;
                $street_name_first = $list_of_street_names[ $which_way_first ] ;
                for ( $which_way_second = $which_way_first + 1 ; $which_way_second <= $#list_of_way_ids ; $which_way_second ++ )
                {
                    $way_id_second = $list_of_way_ids[ $which_way_second ] ;
                    $street_name_second = $list_of_street_names[ $which_way_second ] ;
                    if ( ( $street_name_first ne $street_name_second ) && ( $way_id_first ne $way_id_second ) )
                    {
#                        un-comment next line, and other related lines, if need to view node ID for debugging a specific intersection:
#                        print "node: " . $node_at_storage_position[ $storage_position ] . "\n" ;
                        $lat_lon_location = $lat_lon_location_at_storage_position[ $storage_position ] ;


#--------------------------------------------------
#  For each intersection, write pairs of way IDs
#  and the location (into one file), and write the
#  street name and way ID number into another file.
#  Do this for all combinations of street pairs
#  that meet at the same node.
#  For each pair, write the smaller way ID first,
#  then write the larger way ID second.

                        if ( $lat_lon_location =~ /^([0-9][0-9][0-9][0-9])([0-9]+) ([0-9][0-9][0-9][0-9])([0-9]+)/ )
                        {
                            $latitude_region = $1 ;
                            $latitude_remainder = $2 ;
                            $longitude_region = $3 ;
                            $longitude_remainder = $4 ;
                            $region = $latitude_region . "_" . $longitude_region ;
                            if ( length( $way_id_first ) < length( $way_id_second ) )
                            {
                                $both_way_ids = $way_id_first . " " . $way_id_second ;
                            } elsif ( length( $way_id_second ) < length( $way_id_first ) )
                            {
                                $both_way_ids = $way_id_second . " " . $way_id_first ;
                            } else
                            {
                                $way_id_first_as_number = 0 + substr( $way_id_first , 1 ) ;
                                $way_id_second_as_number = 0 + substr( $way_id_second , 1 ) ;
                                if ( $way_id_first_as_number < $way_id_second_as_number )
                                {
                                    $both_way_ids = $way_id_first . " " . $way_id_second ;
                                } else
                                {
                                    $both_way_ids = $way_id_second . " " . $way_id_first ;
                                }
                            }
                            if ( not( exists( $already_wrote_intersection{ $both_way_ids } ) ) )
                            {

#  2015-jan-20 changed next line; has not been tested:
                                $output_line = $both_way_ids . " " . $latitude_remainder . " " . $longitude_remainder . "\n" ;
#  previous version:
#                                $output_line = $both_way_ids . " " . $latitude_remainder . "_" . $longitude_remainder . "\n" ;

                                $output_lines_intersections_for_region{ $region } .= $output_line ;
                                $count_intersection_info_lines_stored_ready_to_write ++ ;
                                if ( $count_intersection_info_lines_stored_ready_to_write > 50000 )
                                {
                                    foreach $region_to_write ( keys( %output_lines_intersections_for_region ) )
                                    {
                                        open OUT_INTERSECTIONS , ">>" . $file_name_prefix_for_intersections . $region_to_write . '.txt' ;
                                        print OUT_INTERSECTIONS $output_lines_intersections_for_region{ $region_to_write } ;
                                        close OUT_INTERSECTIONS ;
                                    }
                                    %output_lines_intersections_for_region = ( ) ;
                                    $count_intersection_info_lines_stored_ready_to_write = 0 ;
                                }
                                $already_wrote_intersection{ $both_way_ids } = "y" ;
                            }
                            foreach $first_or_second ( @list_first_and_second )
                            {
                                if ( $first_or_second eq "first" )
                                {
                                    $street_name = $street_name_first ;
                                    $way_id = $way_id_first ;
                                } else
                                {
                                    $street_name = $street_name_second ;
                                    $way_id = $way_id_second ;
                                }
                                if ( not( exists( $already_wrote_way_id{ $way_id } ) ) )
                                {
                                    $output_line = $way_id . " " . $street_name . "\n" ;
                                    $output_lines_street_names_for_region{ $region } .= $output_line ;
                                    $count_street_info_lines_stored_ready_to_write ++ ;
                                    if ( $count_street_info_lines_stored_ready_to_write > 50000 )
                                    {
                                        foreach $region_to_write ( keys( %output_lines_street_names_for_region ) )
                                        {
                                            open OUT_STREET_NAMES , ">>" . $file_name_prefix_for_street_names . $region_to_write . '.txt' ;
                                            print OUT_STREET_NAMES $output_lines_street_names_for_region{ $region_to_write } ;
                                            close OUT_STREET_NAMES ;
                                        }
                                        %output_lines_street_names_for_region = ( ) ;
                                        $count_street_info_lines_stored_ready_to_write = 0 ;
                                    }
                                    $already_wrote_way_id{ $way_id } = "y" ;
                                }
                            }
                        }


#--------------------------------------------------
#  Terminate branching and looping.

                    }
                }
            }
        }
    }


#--------------------------------------------------
#  Repeat the loop that handles each node category.

}


#--------------------------------------------------
#  Write any lines that are waiting to be written.

foreach $region_to_write ( keys( %output_lines_intersections_for_region ) )
{
    open OUT_INTERSECTIONS , ">>" . $file_name_prefix_for_intersections . $region_to_write . '.txt' ;
    print OUT_INTERSECTIONS $output_lines_intersections_for_region{ $region_to_write } ;
    close OUT_INTERSECTIONS ;
}
foreach $region_to_write ( keys( %output_lines_street_names_for_region ) )
{
    open OUT_STREET_NAMES , ">>" . $file_name_prefix_for_street_names . $region_to_write . '.txt' ;
    print OUT_STREET_NAMES $output_lines_street_names_for_region{ $region_to_write } ;
    close OUT_STREET_NAMES ;
}
