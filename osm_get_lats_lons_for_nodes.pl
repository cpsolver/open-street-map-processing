#--------------------------------------------------
#       osm_get_lats_lons_for_nodes.pl
#--------------------------------------------------

#  (c) Copyright 2014-2016 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_lats_lons_for_nodes.pl

#  Do not specify output log file so that progress is
#  monitored in the terminal window.


#--------------------------------------------------
#  Specify the INPUT filename prefixes.
#  If there are any changes in the filename prefix,
#  also change the regular expression below.

$directory_node_info = 'G:\OpenStreetMapData\output_files_2015octEarlier\street_nodes' . "\\" ;
$file_name_prefix_for_node_info = $directory_node_info . "output_street_nodes_in_category_" ;

$directory_other_info = 'F:\CitiesBusinessesIntersectionsPostalcodes\calc_results\nodes' . "\\" ;
$file_name_prefix_for_other_info = $directory_other_info . "output_linkages_with_node_suffix_" ;


#--------------------------------------------------
#  Specify and open the OUTPUT file.
#
#  Use internal, not external, drive because
#  files are not big and appending to lots of files
#  is very, very slow using an external drive.

$path_and_filename_for_output = 'F:\CitiesBusinessesIntersectionsPostalcodes\calc_results' . "\\" . "output_node_info_with_lat_lon.txt" ;
open OUTFILE , ">>" . $path_and_filename_for_output ;


#---------------------------------------------------
#  Create the list of node categories that need to be
#  handled.
#  If there are any changes in the filename here,
#  also change the related assignments above.
#
#  Just use the categories based on the street nodes,
#  which allows testing with a subset of street nodes.

if ( opendir( READ_DIR , $directory_node_info ) )
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
#  Clear the values from the prior node category.

    %lat_lon_for_node = ( ) ;


#--------------------------------------------------
#  Read each line of NODE info (within this node
#  category), and store the associated location.

    open( INFILE , "<" . $file_name_prefix_for_node_info . $node_category . '.txt' ) ;
    while( $input_line = <INFILE> )
    {
        chomp( $input_line ) ;
        if ( $input_line =~ /^(n[0-9]+) ([0-9]+ [0-9]+)/ )
        {
            $node_id = $1 ;
            $lat_lon_location = $2 ;
            $lat_lon_for_node{ $node_id } = $lat_lon_location ;
        }
    }
    close( INFILE ) ;


#--------------------------------------------------
#  Read each line of info within this node
#  category, and insert the latitude and longitude.
#  If the line contains both a way ID and a
#  relation ID, remove both the node ID and the
#  way ID.
#  If the line contains a way ID or relation ID,
#  remove the node ID.

    open( INFILE , "<" . $file_name_prefix_for_other_info . $node_category . '.txt' ) ;
    while( $input_line = <INFILE> )
    {
        chomp( $input_line ) ;
        if ( $input_line =~ /^([sbcl]) +(n[0-9]+) +(.+)$/ )
        {
            $data_type = $1 ;
            $node_id = $2 ;
            $remainder_of_line = $3 ;
            if ( exists( $lat_lon_for_node{ $node_id } ) )
            {
                if ( $remainder_of_line =~ /^w[0-9]+ +(r[0-9]+ .+)$/ )
                {
                    $remainder_of_line = $1 ;
                    print OUTFILE $data_type . " " . $lat_lon_for_node{ $node_id } . " " . $remainder_of_line . "\n" ;
                } elsif ( $remainder_of_line =~ /^[wr][0-9]+ / )
                {
                    print OUTFILE $data_type . " " . $lat_lon_for_node{ $node_id } . " " . $remainder_of_line . "\n" ;
                } else
                {
                    print OUTFILE $data_type . " " . $lat_lon_for_node{ $node_id } . " " . $node_id . " " . $remainder_of_line . "\n" ;
                }
            }
        }
    }
    close( INFILE ) ;


#--------------------------------------------------
#  Repeat the loop that handles each node category.

}
