#-------------------------------------------------
#
#       osm_processing_get_cities.pl
#
#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com
#
#  This Perl script runs other Perl scripts that
#  process the Open Street Map data to get the
#  location (by latitude and longitude) and names
#  of cities including townships, boroughs,
#  named neighborhoods, "villages" within cities,
#  etc.
#
#  Usage:
#
#  perl osm_processing_get_cities.pl
#
#  To monitor progress, watch which files are
#  created, and watch the file sizes increase.
#
#
#-------------------------------------------------
#  Start by opening a browser to the GeoNames.org
#  website, click on the "Free Postal Code Data"
#  link that is within the "Downloads" category,
#  then scroll down to the "all_countries.zip"
#  (zipped CSV) file, then download it, open the
#  zip file to access the "all_countries.zip"
#  file, and put that text into a local file
#  named: "PostalCodesAllCountriesLatest.txt"
#
#  A later step checks that this file exists, but
#  it does not verify that the file is a recent
#  version.


#-------------------------------------------------
#  Verify that some needed files exist.

$filename_needed[ 1 ] = 'text_yes.txt' ;
$filename_needed[ 2 ] = 'text_no.txt' ;
$filename_needed[ 3 ] = 'no_content.txt' ;
$filename_needed[ 4 ] = 'planet_relations_only.bz2' ;
$filename_needed[ 5 ] = 'planet_ways_relations_only.bz2' ;
$filename_needed[ 6 ] = 'planet-latest.osm.bz2' ;
$filename_needed[ 7 ] = 'generate_map_density_squares.pl' ;
$filename_needed[ 8 ] = 'PostalCodesAllCountriesLatest.txt' ;
$filename_needed[ 9 ] = 'osm_split_and_abbrev_node_way_relation.pl' ;
$filename_needed[ 10 ] = 'split_on_server.pl' ;
$filename_needed[ 11 ] = 'convert_postal_code_database.pl' ;
$filename_needed[ 12 ] = 'convert_tab_delimited_to_quoted_csv.pl' ;
$filename_needed[ 13 ] = 'merge_city_info_from_postal_into_osm.pl' ;
$filename_needed[ 14 ] = 'remove_column_one.pl' ;
$filename_needed[ 15 ] = 'remove_column_three.pl' ;
$filename_needed[ 16 ] = 'remove_column_two.pl' ;
$filename_needed[ 17 ] = 'osm_remove_unneeded_ways_from_relation_info.pl' ;
$filename_needed[ 18 ] = 'osm_get_way_ids_from_relation_info.pl' ;
$filename_needed[ 19 ] = 'osm_get_prefixed_node_way_pairs.pl' ;
$filename_needed[ 20 ] = 'osm_merge_lats_lons_with_way_ids.pl' ;
$filename_needed[ 21 ] = 'osm_get_lat_lon_min_max.pl' ;
$filename_needed[ 22 ] = 'osm_put_centers_into_city_or_biz_info.pl' ;
$filename_needed[ 23 ] = 'osm_handle_city_info.pl' ;
$filename_needed[ 24 ] = 'osm_split_city_info_by_rank.pl' ;
$filename_needed[ 25 ] = 'osm_join_cities_by_rank.pl' ;

for ( $pointer = 1 ; $pointer <= 25 ; $pointer ++ )
{
    if ( not( -e $filename_needed[ $pointer ] ) )
    {
        print "needed file named " . $filename_needed[ $pointer ] . " not found, so exiting" . "\n" ;
        print "Reminder: The script named ... must be run before running this script." . "\n" ;

#        exit ;

    }

}


#-------------------------------------------------
#  Initialization.

$option_t_space = "-t' '" ;
$character_apostrophe = "'" ;


#-------------------------------------------------
#  For testing, specify what to find and write to
#  the log file.
#
#  Reminder:  If the string ends with a space,
#  and occurance of the string at the end of a
#  line will not be found.

$grep_string_quoted = "'r111194'" ;


#-------------------------------------------------
#  Clear a log file.

system( 'head -v no_content.txt > output_log_city_processing.txt' ) ;
system( 'head -v text_yes.txt >> output_log_city_processing.txt' ) ;
system( 'head -v text_no.txt >> output_log_city_processing.txt' ) ;
print "started writing the file output_log_city_processing.txt" . "\n" ;


#-------------------------------------------------
#  This code is for debugging the loss of node ID
#  number: 9483616092

system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_business_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_city_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_node_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'bzcat planet-latest.osm.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
system( 'head -v output_city_node_info.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


exit ;


#-------------------------------------------------
#  Process the postal codes data.  In addition to
#  supplying postal code data it supplies city
#  information that is merged with the OSM city
#  information.

system( 'head -v PostalCodesAllCountriesLatest.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -n 3 convert_tab_delimited_to_quoted_csv.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl convert_tab_delimited_to_quoted_csv.pl < PostalCodesAllCountriesLatest.txt > output_postal_code_data_quoted_csv_format.txt' ) ;
system( 'head -v output_postal_code_data_quoted_csv_format.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

system( 'head -n 3 convert_postal_code_database.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl convert_postal_code_database.pl < output_postal_code_data_quoted_csv_format.txt > output_log_convert_postal_code_database.txt' ) ;
system( 'head -v output_log_convert_postal_code_database.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -v output_postal_code_info_ready_to_split.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

print "Upload the file named output_postal_code_info_ready_to_split.txt to the website, into the directory /home/newsher2/lookup which is just above where the new postal_codes_new folder will be created.  Then from a terminal change to this directory and run the following command:" . "\n" . "perl ~/batch_scripts/split_on_server.pl < output_file_with_data_to_split.txt > output_log.txt" . "\n" . "Then change file protection to hide from public, then rename directory postal_codes to postal_codes_old and IMMEDIATELY rename postal_codes_new to postal_codes." . "\n" . "Then verify the new postal codes are now working correctly by entering some familiar postal codes." . "\n" ;


#-------------------------------------------------
#  Get the city "relation" info.

# system( 'cat no_content.txt > input_list_of_special_nodes_ways_to_get.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_business_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_city_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'bzcat planet_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
system( 'head -v output_city_relation_info.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Get information from the "ways" that are
#  tagged with info that indicate they relate to
#  a city.

# system( 'cat no_content.txt > input_list_of_special_nodes_ways_to_get.txt' ) ;
system( 'head -v input_list_of_special_nodes_ways_to_get.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_business_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_city_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_way_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'bzcat planet_ways_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
# system( 'cat output_city_way_info.txt > output_city_way_info_tagged_as_city.txt' ) ;
system( 'head -v output_city_way_info_tagged_as_city.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Process the city relation info to exclude way
#  IDs that are not needed because the city has a
#  node that specifies the city center.

system( 'head -n 3 osm_remove_unneeded_ways_from_relation_info.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_remove_unneeded_ways_from_relation_info.pl < output_city_relation_info.txt > output_city_relation_info_without_extra_ways.txt' ) ;
system( 'head -v output_city_relation_info_without_extra_ways.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Create a list of ways that specify a city's
#  boundary when the city is specified as a
#  relation (not a way or node).  This is only
#  needed when a city center location is not
#  specified as part of the relation info.

system( 'head -v output_city_relation_info_without_extra_ways.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -n 3 osm_get_way_ids_from_relation_info.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_get_way_ids_from_relation_info.pl < output_city_relation_info_without_extra_ways.txt > output_way_ids_needed_for_city_relation_info.txt' ) ;
system( 'head -v output_way_ids_needed_for_city_relation_info.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Get the information for "ways" that are
#  needed for city relation info.  These are not
#  necessarily tagged as being related to a city
#  because some of these ways are streets and
#  rivers that are used as city boundaries.

# system( 'cat output_way_ids_needed_for_city_relation_info.txt > input_list_of_special_nodes_ways_to_get.txt' ) ;
system( 'head -v input_list_of_special_nodes_ways_to_get.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_business_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_city_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_way_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'bzcat planet_ways_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
# system( 'cat output_info_for_listed_ways.txt > output_city_way_boundaries_for_relations.txt' ) ;
# system( 'cat output_info_for_listed_nodes.txt > output_city_info_extra_ways_when_getting_for_relations.txt' ) ;
system( 'head -v output_city_info_extra_ways_when_getting_for_relations.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -v output_city_way_boundaries_for_relations.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Create a list of node-and-way pairs and
#  node-and-relation pairs that need to be
#  associated with latitudes and longitudes.
#  Also sort them so that nodes that have the
#  same ending two digits are grouped together.
#
#  This list includes nodes that are used as
#  labels for relations, and includes info for
#  cities that are specified as relations or ways
#  but without specifying even one node, and
#  includes node-and-way pairs for the ways that
#  are tagged as cities (without involving any
#  relation data), and includes nodes within
#  relations that do not have a label node.
#
#  Some unusual cases:
#  w111927 is a religious boundary
#  r4557 and r4534 are groups of village nodes
#  r8411277 and r3049081 have same name but
#    different boundaries, and no label
#  Kinnarp is village relation without label

system( 'head -v output_city_way_info_needed_for_city_relation_info.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -n 3 osm_get_prefixed_node_and_way_or_relation_pairs.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_get_prefixed_node_and_way_or_relation_pairs.pl < output_city_way_info_needed_for_city_relation_info.txt > output_prefixed_node_way_pairs_for_relations.txt' ) ;
system( 'head -v output_prefixed_node_way_pairs_for_relations.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

system( 'head -v output_city_way_info_tagged_as_city.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -n 3 osm_get_prefixed_node_and_way_or_relation_pairs.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_get_prefixed_node_and_way_or_relation_pairs.pl < output_city_way_info_tagged_as_city.txt > output_prefixed_node_way_pairs_for_ways.txt' ) ;
system( 'head -v output_prefixed_node_way_pairs_for_ways.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

system( 'head -v output_city_relation_info_without_extra_ways.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -n 3 osm_get_prefixed_node_and_way_or_relation_pairs.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_get_prefixed_node_and_way_or_relation_pairs.pl < output_city_relation_info_without_extra_ways.txt > output_prefixed_node_relation_pairs.txt' ) ;
system( 'head -v output_prefixed_node_relation_pairs.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

# system( 'cat output_prefixed_node_way_pairs_for_relations.txt > output_prefixed_node_and_way_or_relation_pairs_all.txt' ) ;
# system( 'cat output_prefixed_node_way_pairs_for_ways.txt >> output_prefixed_node_and_way_or_relation_pairs_all.txt' ) ;
# system( 'cat output_prefixed_node_relation_pairs.txt >> output_prefixed_node_and_way_or_relation_pairs_all.txt' ) ;

system( 'head -v output_prefixed_node_and_way_or_relation_pairs_all.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'tail -v output_prefixed_node_and_way_or_relation_pairs_all.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

system( 'echo SORTING FILE >> output_log_city_processing.txt' ) ;
system( 'tail -n 1 output_log_city_processing.txt' ) ;
# system( 'sort ' . $option_t_space . ' -k1,1n output_prefixed_node_and_way_or_relation_pairs_all.txt -o output_sorted_node_and_way_or_relation_pairs.txt' ) ;
system( 'head -v output_sorted_node_and_way_or_relation_pairs.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'tail -v output_sorted_node_and_way_or_relation_pairs.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Get the latitudes and longitudes of the
#  resulting list of nodes, and write them with
#  their associated way IDs.  Also get the
#  latitudes and longitudes of the nodes in
#  city relation info that indicate city center.
#  Omit the node IDs from the output because
#  they have served their purpose of linking ways
#  to latitudes and longitudes.
#
#  Reminder:  This step runs for about a day and
#  a half.




system( 'head -n 3 osm_merge_lats_lons_with_way_relation_ids.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'perl osm_merge_lats_lons_with_way_relation_ids.pl' ) ;
system( 'head -v output_outline_ways_relations_with_lats_lons.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


system( 'echo GREP CHECK >> output_log_city_processing.txt' ) ;
system( 'tail -n 1 output_log_city_processing.txt' ) ;
system( 'grep ' . $grep_string_quoted . ' output_outline_ways_relations_with_lats_lons.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;



exit ;


#-------------------------------------------------
#  Calculate the bounding boxes for the ways.
#  Use the Linux sort command to find the maximum
#  and minimum latitude and longitude for each way.

system( 'head -n 3 remove_column_three.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl remove_column_three.pl < output_outline_ways_relations_with_lats_lons.txt > output_way_or_relation_and_latitude_pairs.txt' ) ;
system( 'head -v output_way_or_relation_and_latitude_pairs.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

system( 'head -n 3 remove_column_two.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl remove_column_two.pl < output_outline_ways_relations_with_lats_lons.txt > output_way_or_relation_and_longitude_pairs.txt' ) ;
system( 'head -v output_way_or_relation_and_longitude_pairs.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

system( 'echo SORTING FILE >> output_log_city_processing.txt' ) ;
system( 'tail -n 1 output_log_city_processing.txt' ) ;
# system( 'sort ' . $option_t_space . ' -k1.2,1n -k2,2n output_way_or_relation_and_latitude_pairs.txt -o output_sorted_way_or_relation_with_latitude.txt' ) ;
system( 'head -v output_sorted_way_or_relation_with_latitude.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

system( 'echo SORTING FILE >> output_log_city_processing.txt' ) ;
system( 'tail -n 1 output_log_city_processing.txt' ) ;
# system( 'sort ' . $option_t_space . ' -k1.2,1n -k2,2n output_way_or_relation_and_longitude_pairs.txt -o output_sorted_way_or_relation_with_longitude.txt' ) ;
system( 'head -v output_sorted_way_or_relation_with_longitude.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;



system( 'echo GREP CHECK >> output_log_city_processing.txt' ) ;
system( 'tail -n 1 output_log_city_processing.txt' ) ;
system( 'grep ' . $grep_string_quoted . ' output_sorted_way_or_relation_with_latitude.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

system( 'echo GREP CHECK >> output_log_city_processing.txt' ) ;
system( 'tail -n 1 output_log_city_processing.txt' ) ;
system( 'grep ' . $grep_string_quoted . ' output_sorted_way_or_relation_with_longitude.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;





system( 'head -n 3 osm_get_lat_lon_min_max.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'perl osm_get_lat_lon_min_max.pl' ) ;
system( 'head -v output_bounding_boxes_for_ways_and_relations.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;




system( 'echo GREP CHECK >> output_log_city_processing.txt' ) ;
system( 'tail -n 1 output_log_city_processing.txt' ) ;
system( 'grep ' . $grep_string_quoted . ' output_bounding_boxes_for_ways_and_relations.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


exit ;


#-------------------------------------------------
#  Use the gathered latitude and longitude info
#  to provide city center locations to the ways
#  and relations.

# system( 'cat output_city_relation_info_without_extra_ways.txt > output_city_or_biz_info_needing_centers.txt' ) ;
# system( 'cat output_city_way_info_tagged_as_city.txt >> output_city_or_biz_info_needing_centers.txt' ) ;
system( 'head -v output_city_or_biz_info_needing_centers.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'tail -v output_city_or_biz_info_needing_centers.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -n 3 osm_put_centers_into_city_or_biz_info.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_put_centers_into_city_or_biz_info.pl' ) ;
system( 'head -v output_city_or_biz_info_with_centers.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------


exit ;


#-------------------------------------------------
#  Get the info about nodes that are clearly
#  indicated as cities, townships, etc.

system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_business_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_city_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_node_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'bzcat planet-latest.osm.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
system( 'head -v output_city_node_info.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


exit ;


#-------------------------------------------------
#  Process the city info.

system( 'head -n 3 osm_handle_city_info.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_handle_city_info.pl < output__city__node__info.txt' ) ;
system( 'head -v output_city_whatever_info.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Generate a density map of the cities.
#  This provides verification of the data.

system( 'head -n 3 remove_column_one.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl remove_column_one.pl < output_outline_ways_with_lats_lons__first_half.txt > output_density_mapable_lats_lons.txt' ) ;
system( 'head -v output_density_mapable_lats_lons.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -n 3 generate_map_density_squares.pl >> output_log_city_processing.txt' ) ;
# system( 'perl generate_map_density_squares.pl < output_density_mapable_lats_lons.txt > output_map_density_squares.txt' ) ;
# system( 'cat map_image_begin.txt > map_full_cities.svg' ) ;
# system( 'cat output_map_density_squares.txt >> map_full_cities.svg' ) ;
# system( 'cat map_image_end.txt >> map_full_cities.svg' ) ;
# system( 'ls map_full_cities.svg >> output_log_cities_processing.txt' ) ;
# system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Merge city information from the (non-OSM)
#  postal code database.

system( 'head -n 3 merge_city_info_from_postal_into_osm.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl merge_city_info_from_postal_into_osm.pl' ) ;
system( 'head -v output_city_whatever_info.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Sort the city info to put more important cities
#  ahead of less important cities of the same
#  name.  For example, ensure Paris France appears
#  before Paris Texas.

system( 'head -n 3 osm_split_city_info_by_rank.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_split_city_info_by_rank.pl' ) ;
system( 'head -v output_cities_split_by_rank.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
system( 'head -n 3 osm_join_cities_by_rank.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl osm_join_cities_by_rank.pl' ) ;
system( 'head -v output_sorted_joined_city_info.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Split the uploadable city info file into
#  multiple files and put those files into a new
#  folder named "cities_new".

system( 'head -n 3 split_on_server.pl >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;
# system( 'perl split_on_server.pl < output_uploadable_cities_info.txt' ) ;
system( 'head -v cities_new/city_info_1234.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;

# system( 'grep multnomah_village cities_new/city_info_1234.txt >> output_log_city_processing.txt' ) ;

system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Show the file sizes.

system( 'ls -sSr output_*.txt >> output_log_city_processing.txt' ) ;
# system( 'wc -l output_*.txt >> output_log_city_processing.txt' ) ;
system( 'tail -n 3 output_log_city_processing.txt' ) ;


#-------------------------------------------------
#  Display instructions for what to do next, which
#  is to compress the data, upload it to the
#  server, then uncompress it.

print "\n\n" . "Do next:  Use the cd command to enter the cities_new folder and execute the following command:" . "\n" ;

print "  zip -r -q uploadable_cities_zipped.zip ." . "\n" ;

print "\n" . "Then upload the created zip file to the NHN server into a new cities_new folder and unzip the file using the following command" . "\n" ;

print "  unzip -r uploadable_cities_zipped.zip" . "\n" ;

