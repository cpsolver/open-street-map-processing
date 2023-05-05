#-------------------------------------------------
#
#       osm_processing_get_intersections.pl
#
#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com
#  Permission to copy and use and modify this
#  software is hereby given to individuals and to
#  businesses with ten or fewer employees if this
#  copyright notice is included in all copies
#  and modified copies.
#  All other rights are reserved.
#  Businesses with more than ten employees are
#  encouraged to contract with small businesses
#  to supply the service of running this software
#  if there are arrangements for either business
#  to make donations to support the Open Street
#  Map project.
#  Disclaimer of Warranty:  THERE IS NO WARRANTY
#  FOR THIS SOFTWARE. THE COPYRIGHT HOLDER PROVIDES
#  THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY
#  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
#  BUT NOT LIMITED TO, THE FITNESS FOR A
#  PARTICULAR PURPOSE.
#  Limitation of Liability:  IN NO EVENT WILL THE
#  COPYRIGHT HOLDER BE LIABLE TO ANYONE FOR
#  DAMAGES, INCLUDING ANY GENERAL, SPECIAL,
#  INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
#  OUT OF THE USE OR INABILITY TO USE THE SOFTWARE.
#
#
#  This Perl script runs other Perl scripts that
#  process the Open Street Map data to get the
#  location (by latitude and longitude) and name
#  of every street intersection, everywhere in the
#  world.  An intersection is named by the names
#  of the two streets that intersect.
#  Keep in mind that freeways do not have
#  intersections.  Also, one street passing over
#  another via a bridge is not an intersection.
#
#  Usage:
#
#  First, if you have not already run the
#  script named "osm_processing_do_all.pl"
#  then run just the beginning of it to
#  get the latitude and longitude of every
#  node.  Then, run:
#
#  perl osm_processing_get_intersections.pl
#
#  To monitor progress, run the Linux "top"
#  command in a separate terminal (to watch
#  memory usage and compression and
#  decompression workloads), and use a "file"
#  utility (to watch which files are created,
#  and watch the file sizes increase).
#
#  To execute just a portion of the code in this
#  script, comment out the lines that are
#  preceded with the text "conlts" which is an
#  abbreviation of the words:
#  "Comment Out Next Line To Skip".


#-------------------------------------------------
#  Verify that some needed files exist.
#
#  The "no_content" file is used at the end
#  to deal with the need for special punctuation
#  at the end.

@filenames_needed = (
'planet_relations_only.bz2' ,
'planet_ways_relations_only.bz2' ,
'osm_split_and_abbrev_node_way_relation.pl' ,
'osm_get_way_ids_from_relation_info.pl' ,
'osm_consolidate_street_info_by_region.pl' ,
'osm_eliminate_non_intersection_street_joins.pl' ,
'osm_exclude_intersections_with_listed_street_ids.pl' ,
'osm_find_intersections_and_merge_lats_lons.pl' ,
'osm_join_intersection_info_files.pl' ,
'osm_generate_uploadable_street_words.pl' ,
'osm_get_street_node_way_pairs.pl' ,
'osm_handle_sorted_street_names.pl' ,
'osm_prepare_street_info_for_sorting.pl' ,
'osm_generate_mapable_intersection_lats_lons.pl' ,
'split_on_server.pl' ,
'remove_column_one.pl' ,
'remove_column_two.pl' ,
'remove_column_three.pl' ,
'generate_map_density_squares.pl' ,
'map_image_begin.txt' ,
'map_image_end.txt' ,
'text_yes.txt' ,
'text_no.txt' ,
'no_content.txt' ) ;

foreach $filename ( @filenames_needed )
{
    if ( not( -e $filename ) )
    {
        print "needed file named " . $filename . " not found, so exiting" . "\n" ;
        exit ;
    }

}


#-------------------------------------------------
#  Initialization.

$option_t_space = "-t' '" ;
$character_apostrophe = "'" ;


#-------------------------------------------------
#  Clear the output log file.

system( 'head -v no_content.txt > output_log_intersection_processing.txt' ) ;
system( 'head -v text_yes.txt >> output_log_intersection_processing.txt' ) ;
system( 'head -v text_no.txt >> output_log_intersection_processing.txt' ) ;
print "started writing the file output_log_intersection_processing.txt" . "\n" ;


#-------------------------------------------------
#  Create a needed folder, or verify that
#  this folder already exists.
#  The "p" switch, for "mkdir", specifies
#  "if it does not exist".

# conlts:
 system( 'mkdir -p ./street_node_way_pairs >> output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Get information from the "relations" that are
#  tagged in ways that indicate they relate to
#  a street.
#
#  This step takes about a quarter of an hour.

system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

system( 'cat no_content.txt > input_list_of_special_nodes_ways_to_get.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_street_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_business_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_city_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_relation_info.txt' ) ;

# conlts:
 system( 'bzcat planet_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;

# conlts:
 system( 'cat output_street_relation_info.txt > output_street_relation_info_tagged_as_street.txt' ) ;

system( 'head -v output_street_relation_info_tagged_as_street.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Generate a list of the way IDs that appear in
#  the street relation info.

system( 'head -n 3 osm_get_way_ids_from_relation_info.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_get_way_ids_from_relation_info.pl < output_street_relation_info_tagged_as_street.txt > output_way_ids_from_street_relation_links.txt' ) ;

system( 'head -v output_way_ids_from_street_relation_links.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Get information from the "ways" that are
#  tagged in ways that indicate they relate to
#  a street.
#
#  This step omits ways labelled as
#  "highway_path".  However there is one way that
#  is tagged with "highway_paths" (plural).
#
#  This step takes more than 10 hours.

system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

system( 'cat output_way_ids_from_street_relation_links.txt > input_list_of_special_ways_to_get.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_street_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_business_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_city_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_way_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'bzcat planet_ways_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;

# conlts:
 system( 'cat output_street_way_info.txt > output_street_way_info_tagged_as_street.txt' ) ;
system( 'head -v output_street_way_info_tagged_as_street.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Create lists of node IDs and their associated
#  way ID or relation ID.  The output is 100 files
#  that are written to the "street_node_way_pairs"
#  folder.
#
#  This step takes less than an hour.

system( 'head -n 3 osm_get_street_node_way_pairs.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_get_street_node_way_pairs.pl' ) ;

system( 'head -v street_node_way_pairs/node_way_pairs_in_group_00.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'tail -v street_node_way_pairs/node_way_pairs_in_group_00.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Merge the latitudes and longitudes with the
#  pair of ways (or sometimes a pair of a way and
#  a relation, or two relations) that define an
#  intersection.  The node numbers associate
#  these two pieces of data, but the node IDs are
#  not included in the output.  To keep
#  associative arrays from getting too big, and
#  to reduce the combination of checks needed,
#  the input data is split and handled based on
#  the last two digits of the node ID number.
#  The output data is split into ten files.
#  Then join the ten files into a single file.
#
#  This step takes about 6 hours.

# conlts:
 system( 'rm output_intersections_with_lats_lons_group_?.txt' ) ;

system( 'head -n 3 osm_find_intersections_and_merge_lats_lons.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_find_intersections_and_merge_lats_lons.pl' ) ;

system( 'head -v output_intersections_with_lats_lons_group_0.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_join_intersection_info_files.pl' ) ;

system( 'head -v output_joined_intersection_info_before_exclusions.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Identify street IDs that should be excluded.
#  Specifically exclude streets with names that
#  contain a left paren (&#40;),
#  right paren (&#41;),
#  semicolon (&#59;),
#  the text "highway_path",
#  "highway_bus_stop", or
#  "N&#58;N" (which is "N:N") where "N" indicates
#  any digit.
#  Colons (&#58;) alone are not considered because
#  they appear in the text "name:en".
#  Typically these complicated names apply to
#  highways rather than neighborhood
#  intersections.
#  Currently removes about 10 percent of the
#  intersections.
#
#  The "P" option uses Perl regular expression
#  syntax.

system( 'echo USING GREP >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 1 output_log_intersection_processing.txt' ) ;

$grep_regular_expression = '(&#40;)|(&#41;)|(&#59;)|([0-9]&#58;[0-9])|( highway_path)|( highway_bus_stop)|( \?\?+ )' ;

# conlts:
 system( 'grep -P ' . "'" . $grep_regular_expression . "'" . ' output_street_relation_info_tagged_as_street.txt > output_street_ids_to_exclude.txt' ) ;

# conlts:
 system( 'grep -P ' . "'" . $grep_regular_expression . "'" . ' output_street_way_info_tagged_as_street.txt >> output_street_ids_to_exclude.txt' ) ;

system( 'head -v output_street_ids_to_exclude.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'tail -v output_street_ids_to_exclude.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Remove from the intersection info the
#  intersections at which one of the two street
#  IDs is a street to be excluded.
#  This reduces the number of intersections by
#  about 10 percent.  It reduces the data size by
#  about 75 percent, probably because the streets
#  with excluded naming conventions tend to be
#  for long highways.  Neighborhood intersections
#  are not much affected by this reduction.

system( 'head -n 3 osm_exclude_intersections_with_listed_street_ids.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_exclude_intersections_with_listed_street_ids.pl' ) ;

system( 'head -v output_street_intersections_after_exclusions.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Gather street information that will be sorted
#  and merged based on the street ID number.  The
#  merge brings together region IDs -- which look
#  like "1063_1010" -- and street names.

system( 'head -v output_street_relation_info_tagged_as_street.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_street_way_info_tagged_as_street.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_street_intersections_after_exclusions.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -n 3 osm_prepare_street_info_for_sorting.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_prepare_street_info_for_sorting.pl' ) ;

system( 'head -v output_sortable_relation_ids_and_names.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_sortable_way_ids_and_names.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_sortable_street_ids_and_region_ids.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Sort and merge the street information so that
#  each street name is followed by the region IDs
#  in which that street intersects with another
#  street.
#
#  The "k" option specifies which space-delimited
#  fields to sort on.  The number after the comma
#  is used to limit that sort to just that
#  field instead of including the remainder of
#  the line as part of that sort.  The decimal
#  point in the "k" option specifies the
#  character position within the specified
#  field.  The "n" option specifies a numeric
#  sort.
#  The "t" option is used to change the
#  recognized field separator from the default
#  to (just) a space.  Do not use the "u"
#  option because it eliminates duplicate
#  (non-unique) values even if the remainder of
#  the line is different.

# conlts:
 system( 'cat output_sortable_relation_ids_and_names.txt > output_regions_names_merged_by_street_id.txt' ) ;
# conlts:
 system( 'cat output_sortable_way_ids_and_names.txt >> output_regions_names_merged_by_street_id.txt' ) ;
# conlts:
 system( 'perl remove_duplicate_adjacent_lines.pl < output_sortable_street_ids_and_region_ids.txt >> output_regions_names_merged_by_street_id.txt' ) ;

system( 'echo SORTING FILE >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 1 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'sort ' . $option_t_space . ' -k1.2,1n -k2,2n output_regions_names_merged_by_street_id.txt -o output_regions_names_sorted_by_street_id.txt' ) ;

system( 'head -v output_regions_names_sorted_by_street_id.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'tail -v output_regions_names_sorted_by_street_id.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Generate the lists of street names and street
#  words, along with which regions have those
#  street names and words.

system( 'head -n 3 osm_handle_sorted_street_names.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_handle_sorted_street_names.pl' ) ;

system( 'head -v output_sortable_street_names.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_sortable_street_words.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_sortable_regions_streets.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Sort the street names to create the uploadable
#  street name info.

system( 'echo SORTING FILE >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 1 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'sort ' . $option_t_space . ' -k2,2 output_sortable_street_names.txt -o output_uploadable_street_names.txt' ) ;

system( 'head -v output_uploadable_street_names.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Sort the list of street words.

system( 'echo SORTING FILE >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 1 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'sort ' . $option_t_space . ' -k1,1 -k2,2 -k3,3 output_sortable_street_words.txt -o output_sorted_street_words.txt' ) ;

system( 'head -v output_sorted_street_words.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Write the multiple street IDs for each street
#  word on the same line, along with the region
#  ID.

system( 'head -n 3 osm_generate_uploadable_street_words.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_generate_uploadable_street_words.pl' ) ;

system( 'head -v output_uploadable_street_words.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Eliminate intersection name pairs where both
#  street names are the same, such as
#  "La Costa Avenue & La Costa Avenue".  These do
#  not affect search results because they are
#  avoided by the lookup code, but those
#  intersections use "disk" storage space.  Also
#  remove intersections for which either street
#  name is missing from the region-specific
#  street name info.

system( 'head -n 3 osm_swap_street_ids_in_intersection_data.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_swap_street_ids_in_intersection_data.pl < output_street_intersections_after_exclusions.txt > temp_output_intersections_with_swapped_ids.txt' ) ;

system( 'head -v temp_output_intersections_with_swapped_ids.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

system( 'echo SORTING FILE >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 1 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'cat output_sortable_regions_streets.txt temp_output_intersections_with_swapped_ids.txt > temp_merged_intersections_and_street_names.txt' ) ;
# conlts:
 system( 'sort -k1,1 temp_merged_intersections_and_street_names.txt -o output_merged_sorted_intersections_and_street_names.txt' ) ;

system( 'head -v output_merged_sorted_intersections_and_street_names.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -n 3 osm_eliminate_non_intersection_street_joins.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_eliminate_non_intersection_street_joins.pl' ) ;

system( 'head -v output_uploadable_street_intersections.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_log_street_joins.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'tail -v output_log_street_joins.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  View the three uploadable files to verify they
#  have the correct data types.

system( 'head -v output_uploadable_street_intersections.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_uploadable_street_names.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -v output_uploadable_street_words.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Generate a density map of the intersections.
#  This provides verification of the data.

system( 'head -n 3 osm_generate_mapable_intersection_lats_lons.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_generate_mapable_intersection_lats_lons.pl < output_uploadable_street_intersections.txt > output_density_mapable_lats_lons.txt' ) ;

system( 'head -v output_density_mapable_lats_lons.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -n 3 generate_map_density_squares.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl generate_map_density_squares.pl < output_density_mapable_lats_lons.txt > output_map_density_squares.txt' ) ;
# conlts:
 system( 'cat map_image_begin.txt > map_full_intersections.svg' ) ;
# conlts:
 system( 'cat output_map_density_squares.txt >> map_full_intersections.svg' ) ;
# conlts:
 system( 'cat map_image_end.txt >> map_full_intersections.svg' ) ;

system( 'ls -l map_full_intersections.svg >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Split the uploadable street name file into
#  multiple files and put those files into a new
#  folder named "street_names_new".

system( 'head -n 3 split_on_server.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'rm street_names_new/pattern_*/street_names_category_*.txt' ) ;
# conlts:
 system( 'perl split_on_server.pl < output_uploadable_street_names.txt' ) ;

system( 'head -v street_names_new/pattern_14/street_names_category_6214.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Split the uploadable street word file into
#  multiple files and put those files into a new
#  folder named "street_words_new".

system( 'head -n 3 split_on_server.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'rm street_words_new/lat9_*/street_words_category_*.txt' ) ;
# conlts:
 system( 'perl split_on_server.pl < output_uploadable_street_words.txt' ) ;

system( 'head -v street_words_new/lat9_1045/street_words_category_1045_0877.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'grep sandy street_words_new/lat9_1045/street_words_category_1045_0877.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Split the uploadable street intersection file
#  into multiple files and put those files into a
#  new folder named "street_intersections_new".

system( 'head -n 3 split_on_server.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'rm intersections_new/lat9_*/intersections_category_*.txt' ) ;
# conlts:
 system( 'perl split_on_server.pl < output_uploadable_street_intersections.txt' ) ;

system( 'head -v intersections_new/lat9_1045/intersections_category_1045_0877.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Create a version of the intersection data file
#  that uses standard decimal signed numbers for
#  latitude and longitude.

system( 'head -v output_uploadable_street_intersections.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -n 3 osm_prepare_to_convert_intersection_lats_lons_to_decimal.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_prepare_to_convert_intersection_lats_lons_to_decimal.pl < output_uploadable_street_intersections.txt > output_pre_converted_for_intersections_decimal.txt' ) ;

system( 'head -v output_pre_converted_for_intersections_decimal.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;
system( 'head -n 3 osm_convert_lats_lons_to_decimal.pl >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;

# conlts:
 system( 'perl osm_convert_lats_lons_to_decimal.pl < output_pre_converted_for_intersections_decimal.txt > output_uploadable_street_intersections_decimal.txt' ) ;

system( 'head -v output_uploadable_street_intersections_decimal.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Show the file sizes.

system( 'ls -sSr output_*.txt >> output_log_intersection_processing.txt' ) ;
# system( 'wc -l output_*.txt >> output_log_intersection_processing.txt' ) ;
system( 'tail -n 3 output_log_intersection_processing.txt' ) ;


#-------------------------------------------------
#  Display instructions for what to do next, which
#  is to compress the data, upload it to the
#  server, then uncompress it.

print "\n\n" . "Do next:  Use the cd command to enter the new folders (intersections_new, street_names_new, street_words_new) and execute the following commands which must include the period at the end:" . "\n" ;

print "  zip -r -q uploadable_intersections_zipped.zip ." . "\n" ;
print "  zip -r -q uploadable_street_names_zipped.zip ." . "\n" ;
print "  zip -r -q uploadable_street_words_zipped.zip ." . "\n" ;

print "\n" . "Then upload the created zip files to the server into new folders with the same folder names and unzip each file using the following command:" . "\n" ;

print "  unzip uploadable_street_XXXXXs_zipped.zip" . "\n" ;


#-------------------------------------------------
#  All done handling intersections.
