#-------------------------------------------------
#
#       osm_processing_get_businesses.pl
#
#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com
#
#  This Perl script runs other Perl scripts that
#  process the Open Street Map data to get the
#  location (by latitude and longitude) and names
#  of single-location (non-chain) businesses.
#  Also it gets website URLs when supplied, and
#  the business type.
#
#  Usage:
#
#  perl osm_processing_get_businesses.pl
#
#  To monitor progress, watch which files are
#  created, and watch the file sizes increase.
#
#
#-------------------------------------------------
#  Verify that some needed files exist.
#
#  The "no_content" file is repeated at the end
#  to deal with the need for no comma at the end.

$filenames_needed = {
'no_content.txt' ,
'text_yes.txt' ,
'text_no.txt' ,
'planet-latest.osm.bz2' ,
'osm_get_node_lats_lons.pl' ,
'osm_filter_ways_relations_only.pl' ,
'generate_map_density_squares.pl' ,
'osm_split_and_abbrev_node_way_relation.pl' ,
'split_on_server.pl' ,
'remove_column_one.pl' ,
'remove_column_two.pl' ,
'remove_column_three.pl' ,
'osm_remove_unneeded_ways_from_relation_info.pl' ,
'osm_get_way_ids_from_relation_info.pl' ,
'osm_get_prefixed_node_way_pairs.pl' ,
'osm_merge_lats_lons_with_way_ids.pl' ,
'osm_get_lat_lon_min_max.pl' ,
'osm_put_centers_into_city_or_biz_info.pl' ,
'osm_handle_biz_info.pl' ,
'osm_split_biz_info_by_rank.pl' ,
'osm_join_biz_info_by_rank.pl' ,
'no_content.txt' }

foreach $filename ( @filenames_needed )
{
    if ( not( -e $filename ) )
    {
        print "needed file named " . $filename . " not found, so exiting" . "\n" ;

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

system( 'head -v no_content.txt > output_log_biz_processing.txt' ) ;
system( 'head -v text_yes.txt >> output_log_biz_processing.txt' ) ;
system( 'head -v text_no.txt >> output_log_biz_processing.txt' ) ;
print "started writing the file output_log_biz_processing.txt" . "\n" ;


#-------------------------------------------------
#  Get the latitude and longitude of every node
#  and put that info into 100 compressed files.
#  Also send a copy of the way and relation to
#  standard output so that it will by compressed
#  into a separate file, which allows that data
#  to be accessed without reading the node data.

system( 'head -n 3 osm_get_node_lats_lons.pl >> output_log_biz_processing.txt' ) ;
system( 'tail -n 3 output_log_biz_processing.txt' ) ;
system( 'bzcat planet_relations_only.bz2 | perl osm_get_node_lats_lons.pl | bzip2 > planet_ways_relations_only.bz2' ) ;
system( 'head -v output_biz_relation_info.txt >> output_log_biz_processing.txt' ) ;
system( 'tail -n 3 output_log_biz_processing.txt' ) ;

exit ;


#-------------------------------------------------
#  Create a compressed file that contains just the
#  relation data.

system( 'cat text_yes.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
system( 'bzcat planet_ways_relations_only.bz2 | perl osm_filter_ways_relations_only.pl | bzip2 > planet_relations_only.bz2' ) ;


exit ;


#-------------------------------------------------
#  Get the business "relation" info.

# system( 'cat no_content.txt > input_list_of_special_nodes_ways_to_get.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_business_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_city_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_biz_processing.txt' ) ;
system( 'tail -n 3 output_log_biz_processing.txt' ) ;
# system( 'bzcat planet_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
system( 'head -v output_city_relation_info.txt >> output_log_biz_processing.txt' ) ;
system( 'tail -n 3 output_log_biz_processing.txt' ) ;

exit ;


#-------------------------------------------------
#  Get information from the "ways" that are
#  tagged with info that indicate they relate to
#  a business.

# system( 'cat no_content.txt > input_list_of_special_nodes_ways_to_get.txt' ) ;
system( 'head -v input_list_of_special_nodes_ways_to_get.txt >> output_log_biz_processing.txt' ) ;
system( 'tail -n 3 output_log_biz_processing.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_business_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_city_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
# system( 'cat text_yes.txt > yes_or_no_get_way_info.txt' ) ;
# system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_biz_processing.txt' ) ;
system( 'tail -n 3 output_log_biz_processing.txt' ) ;
# system( 'bzcat planet_ways_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
# system( 'cat output_biz_way_info.txt > output_biz_way_info_tagged_as_biz.txt' ) ;
system( 'head -v output_biz_way_info_tagged_as_biz.txt >> output_log_biz_processing.txt' ) ;
system( 'tail -n 3 output_log_biz_processing.txt' ) ;

exit ;


#-------------------------------------------------
#  Process the business relation info to exclude
#  ways that are not needed because the business
#  has a node that specifies its center latitude
#  and longitude.  If the business has an
#  excessive number of nodes or ways, ignore it
#  because it is unlikely to be a single-location
#  business.

# perl osm_handle_node_way_ids_in_relations.pl < output_business_relation_info.txt > output_business_relation_info_without_extra_ways.txt

# cat output_node_way_ids_needed_for_relation_info.txt > output_node_way_ids_needed_for_business_relation_info.txt

# rm output_node_way_ids_needed_for_relation_info.txt


#-------------------------------------------------
#  Process the business info.


# need: output_lats_lons_for_listed_nodes.txt
# perl osm_get_midpoints_for_way_info.pl


#  Reminder: verify exists:
# ls output_business_info_all_nodes_ways_relations.txt


# perl osm_handle_business_info.pl > output_log_osm_handle_business_info.txt


