#-------------------------------------------------
#
#       osm_processing_do_all.pl
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
#-------------------------------------------------
#
#  This Perl script runs other Perl scripts that
#  process the Open Street Map data to get the
#  info for businesses and cities.
#
#  Before running this script check the settings
#  in the code to verify it is currently set up
#  to get the info you need, and does not waste
#  time getting info you do not need.  For
#  example, business info should be updated often
#  but cities seldom change
#
#  Usage:
#
#  perl osm_processing_do_all.pl
#
#  As an alternative, put the above command into
#  a batch file such as "do_osm_processing.sh"
#  and from the terminal execute the following
#  command:
#
#  bash do_osm_processing.sh
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
#
#
#-------------------------------------------------
#  Reminder:  The Open Street Map data is stored
#  as "nodes" (similar to points), "ways" (similar
#  to lines), and "relations" (similar to groups
#  of points or lines).


#-------------------------------------------------
#  Verify that some needed files exist.
#
#  The "no_content" file is repeated at the end
#  to deal with the need for special punctuation
#  at the end.

@filenames_needed = (
'planet-latest.osm.bz2' ,
'osm_get_node_lats_lons_and_separate_info.pl' ,
'osm_filter_ways_relations_only.pl' ,
'osm_split_and_abbrev_node_way_relation.pl' ,
'osm_get_prefixed_pairs_from_way_info.pl' ,
'osm_get_prefixed_pairs_from_relation_info.pl' ,
'osm_merge_lats_lons_with_way_relation_ids.pl' ,
'osm_get_lat_lon_min_max.pl' ,
'osm_put_centers_into_city_or_biz_info.pl' ,
'osm_handle_city_info.pl' ,
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
#  For testing, specify what to find and log in
#  the log file.
#
#  Reminder:  If the string ends with a space,
#  an occurance of the string at the end of a
#  line will not be found.

$grep_string_quoted = "'n20831347'" ;


#-------------------------------------------------
#  Clear the output log file.

system( 'head -v no_content.txt > output_log_all_processing.txt' ) ;
system( 'head -v text_yes.txt >> output_log_all_processing.txt' ) ;
system( 'head -v text_no.txt >> output_log_all_processing.txt' ) ;
print "started writing the file output_log_all_processing.txt" . "\n" ;


#-------------------------------------------------
#  The following command is only needed once and
#  only to create a shortened version of node
#  data for testing purposes.

# system( 'bzcat planet-latest.osm.bz2 | perl grep_special_get_node_data.pl > output_sample_nodes_xml.txt' ) ;


#-------------------------------------------------
#  Get the latitude and longitude of every node
#  and put that info into 100 compressed files.
#
#  At the same time copy the way and relation
#  data to a separate compressed file so the
#  way and relation data can be accessed without
#  first reading the node data.
#
#  Reminder:  The full version of this step
#  runs for a few days!

system( 'head -n 3 osm_get_node_lats_lons_and_separate_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#  Reminder:  The following version of commands are just for testing!
#  Comment them out, and uncomment the full version,
#  when not testing.
# system( 'head output_sample_nodes_xml.txt > output_sample_nodes_xml_first_lines.txt' ) ;
# system( 'perl osm_get_node_lats_lons_and_separate_info.pl < output_sample_nodes_xml.txt > temp_ignore.txt' ) ;
# system( 'hexdump -n 200 lats_lons_in_groups/output_packed_lats_lons_in_group_02.bin > temp_dump_02.txt' ) ;
# system( 'hexdump -n 200 lats_lons_in_groups/output_packed_lats_lons_in_group_29.bin > temp_dump_29.txt' ) ;
# system( 'perl osm_test_binary_read.pl > output_test_binary_read.txt' ) ;


#  Reminder:  The following full version runs for a few days!
# conlts:
 system( 'bzcat planet-latest.osm.bz2 | perl osm_get_node_lats_lons_and_separate_info.pl | bzip2 > planet_ways_relations_only.bz2' ) ;


system( 'head -v output_log_from_get_lats_lons_separate.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  For debugging, extract a sample of the ways
#  data, and show the first few lines in the log
#  file.

# conlts:
 system( 'bzcat planet_ways_relations_only.bz2 | head -n 50000 > output_sample_of_ways_info.txt' ) ;
# conlts:
 system( 'head -n 3 output_sample_of_ways_info.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Create a compressed file that contains just the
#  relation data.
#
#  Reminder:  This step runs for more than a day!

system( 'cat text_yes.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;

# conlts:
 system( 'bzcat planet_ways_relations_only.bz2 | perl osm_filter_ways_relations_only.pl | bzip2 > planet_relations_only.bz2' ) ;


#-------------------------------------------------
#  Get the "relation" info for businesses and
#  cities.
#
#  Reminder:  If testing is needed, can insert
#  "| head -n 50000000 |" into the line that runs
#  the perl script.
#  Specifically:  system( 'bzcat planet_relations_only.bz2 | head -n 50000000 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
#
#  Reminder:  When the output of the "head"
#  utility goes to a file instead of being piped
#  to a perl script, use the ">" symbol instead
#  of the "|" (vertical line).
#
#  Reminder:  This step runs for about an hour.

# conlts:
 system( 'bzcat planet_relations_only.bz2 | head -n 50000 > output_sample_of_relations_info.txt' ) ;

system( 'head -n 3 output_sample_of_relations_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'cat no_content.txt > input_list_of_special_ways_to_get.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_street_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_business_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_city_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'bzcat planet_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;

system( 'head -v output_business_relation_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_city_relation_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_street_relation_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Check for information that previously was
#  missing.

$grep_string_quoted = "'r3048270'" ;

# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_city_relation_info.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Process the business and city relation info to
#  exclude way IDs that are not needed because the
#  business or city has a node that specifies the
#  center.  For the remaining nodes and ways,
#  write the node and relation pairs and the way
#  and relation pairs.  Ignore any relation IDs
#  that appear as links in the relation info
#  because those complications are unlikely to
#  affect the center location.

system( 'head -n 3 osm_get_just_needed_nodes_and_ways_from_relation_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'perl osm_get_just_needed_nodes_and_ways_from_relation_info.pl < output_business_relation_info.txt > output_business_relation_info_without_extra_ways.txt' ) ;

system( 'head -v output_business_relation_info_without_extra_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'cat output_node_relation_pairs.txt > output_needed_nodes_relations_in_biz_relations.txt' ) ;

system( 'head -v output_needed_nodes_relations_in_biz_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'cat output_way_relation_pairs.txt > output_needed_ways_relations_in_biz_relations.txt' ) ;

system( 'head -v output_needed_ways_relations_in_biz_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -n 3 osm_get_just_needed_nodes_and_ways_from_relation_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'perl osm_get_just_needed_nodes_and_ways_from_relation_info.pl < output_city_relation_info.txt > output_city_relation_info_without_extra_ways.txt' ) ;

system( 'head -v output_city_relation_info_without_extra_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'cat output_node_relation_pairs.txt > output_needed_nodes_relations_in_city_relations.txt' ) ;

system( 'head -v output_needed_nodes_relations_in_city_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'cat output_way_relation_pairs.txt > output_needed_ways_relations_in_city_relations.txt' ) ;

system( 'head -v output_needed_ways_relations_in_city_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'tail -v output_needed_ways_relations_in_city_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Check for information that previously was
#  missing.

$grep_string_quoted = "'r3048270'" ;

# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_city_relation_info_without_extra_ways.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;

$grep_string_quoted = "'w228173529'" ;

# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_needed_ways_relations_in_city_relations.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Create a list of ways that specify the boundary
#  of a business or city that is specified as a
#  relation (not a way or node).  This is only
#  needed for cities and businesses for which a
#  center location is not specified as part of
#  the relation info.  The resulting list is put
#  into a single file that covers both businesses
#  and cities.

system( 'head -n 3 remove_column_two.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'perl remove_column_two.pl < output_needed_ways_relations_in_biz_relations.txt > output_needed_ways_in_biz_and_city_relations.txt' ) ;

system( 'head -v output_needed_ways_in_biz_and_city_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -n 3 remove_column_two.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'perl remove_column_two.pl < output_needed_ways_relations_in_city_relations.txt >> output_needed_ways_in_biz_and_city_relations.txt' ) ;

system( 'tail -v output_needed_ways_in_biz_and_city_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Check for information that previously was
#  missing.

$grep_string_quoted = "'w330751369'" ;

# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_needed_ways_in_biz_and_city_relations.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Get information from the "ways" that are
#  tagged with info that indicate they relate to
#  a business or city.  Also get information for
#  the ways that are needed to calculate
#  locations for business and city relations.
#
#  Reminder:  For testing can insert the "head"
#  command as in:
# ... ( 'bzcat planet_ways_relations_only.bz2 | head -n 50000000 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;
#
#  Reminder:  This step runs for about two days.

# conlts:
 system( 'cat output_needed_ways_in_biz_and_city_relations.txt > input_list_of_special_ways_to_get.txt' ) ;

system( 'head -v input_list_of_special_ways_to_get.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_business_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_city_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_node_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_way_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'bzcat planet_ways_relations_only.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;

# conlts:
 system( 'cat output_business_way_info.txt > output_biz_way_info_tagged_as_biz.txt' ) ;
system( 'head -v output_biz_way_info_tagged_as_biz.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_city_way_info.txt > output_city_way_info_tagged_as_city.txt' ) ;
system( 'head -v output_city_way_info_tagged_as_city.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_info_for_listed_ways.txt > output_way_info_for_listed_biz_and_city_ids_in_relations.txt' ) ;
system( 'head -v output_way_info_for_listed_biz_and_city_ids_in_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Check for information that previously was
#  missing.

$grep_string_quoted = "'w330751369'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_way_info_for_listed_biz_and_city_ids_in_relations.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Delete the files that have been copied and
#  which otherwise will be overwritten the next
#  time the perl script
#  "osm_split_and_abbrev_node_way_relation.pl"
#  is used.

# conlts:
 system( 'rm output_business_way_info.txt' ) ;
# conlts:
 system( 'rm output_city_way_info.txt' ) ;
# conlts:
 system( 'rm output_info_for_listed_ways.txt' ) ;


#-------------------------------------------------
#  Get node and relation pairs from the business
#  and city relation info, put them into lists,
#  and insert a "prefix" in the first column.
#  The prefix is the last two digits of the node
#  ID number.

system( 'head -v output_business_relation_info_without_extra_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_get_prefixed_pairs_from_relation_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl osm_get_prefixed_pairs_from_relation_info.pl < output_business_relation_info_without_extra_ways.txt > output_prefixed_pairs_from_business_relations.txt' ) ;
system( 'head -v output_prefixed_pairs_from_business_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -v output_city_relation_info_without_extra_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_get_prefixed_pairs_from_relation_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl osm_get_prefixed_pairs_from_relation_info.pl < output_city_relation_info_without_extra_ways.txt > output_prefixed_pairs_from_city_relations.txt' ) ;
system( 'head -v output_prefixed_pairs_from_city_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Get node and way pairs that are needed for
#  business and city relation info, put them into
#  a list, and insert a "prefix" in the first
#  column.  The prefix is the last two digits of
#  the node ID number.  Although this info relates
#  to relations, the relation IDs are not in this
#  info.

system( 'head -v output_way_info_for_listed_biz_and_city_ids_in_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_get_prefixed_pairs_from_node_way_pairs_for_relation_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl osm_get_prefixed_pairs_from_node_way_pairs_for_relation_info.pl < output_way_info_for_listed_biz_and_city_ids_in_relations.txt > output_prefixed_node_way_pairs_for_relation_info.txt' ) ;
system( 'head -v output_prefixed_node_way_pairs_for_relation_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Check for information that previously was
#  missing.

$grep_string_quoted = "'w330751369'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_prefixed_node_way_pairs_for_relation_info.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;

$grep_string_quoted = "'n199650439'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_prefixed_node_way_pairs_for_relation_info.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Get node and way pairs from the way info, put
#  them into lists, and insert a "prefix" in the
#  first column.  The prefix is the last two
#  digits of the node ID number.
#
#  Reminder, none of the city and business way
#  info includes "label_at_..." info so there
#  is no need to reduce the number of nodes to
#  find.  The perl script named
#  "osm_remove_unneeded_nodes_from_way_info.pl"
#  was written and tested but found no such
#  labels.

system( 'head -v output_biz_way_info_tagged_as_biz.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_get_prefixed_pairs_from_way_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl osm_get_prefixed_pairs_from_way_info.pl < output_biz_way_info_tagged_as_biz.txt > output_prefixed_pairs_from_business_ways.txt' ) ;
system( 'head -v output_prefixed_pairs_from_business_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -v output_city_way_info_tagged_as_city.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_get_prefixed_pairs_from_way_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl osm_get_prefixed_pairs_from_way_info.pl < output_city_way_info_tagged_as_city.txt > output_prefixed_pairs_from_city_ways.txt' ) ;
system( 'head -v output_prefixed_pairs_from_city_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Combine the node-and-way pairs and
#  node-and-relation pairs into a single list.
#
#  This list includes nodes that are used as
#  labels for relations, and includes info for
#  businesses and cities that are specified as
#  relations or ways but without specifying just
#  one node, and includes node-and-way pairs for
#  the ways that are tagged as cities and
#  businesses (without involving any relation
#  data), and includes nodes within relations
#  that do not have a label node.
#
#  Some unusual cases:
#  w111927 is a religious boundary
#  r4557 and r4534 are groups of village nodes
#  r8411277 and r3049081 have same name but
#    different boundaries, and no label
#  Kinnarp is village relation without a label

# conlts:
 system( 'echo COMBINING FILES >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_prefixed_pairs_from_business_relations.txt > output_prefixed_node_and_way_or_relation_pairs_all.txt' ) ;
# conlts:
 system( 'cat output_prefixed_pairs_from_city_relations.txt >> output_prefixed_node_and_way_or_relation_pairs_all.txt' ) ;
# conlts:
 system( 'cat output_prefixed_pairs_from_business_ways.txt >> output_prefixed_node_and_way_or_relation_pairs_all.txt' ) ;
# conlts:
 system( 'cat output_prefixed_pairs_from_city_ways.txt >> output_prefixed_node_and_way_or_relation_pairs_all.txt' ) ;
# conlts:
 system( 'cat output_prefixed_node_way_pairs_for_relation_info.txt >> output_prefixed_node_and_way_or_relation_pairs_all.txt' ) ;


#-------------------------------------------------
#  Sort the list so that nodes that have the same
#  ending two digits are grouped together.

# conlts:
 system( 'echo SORTING FILE >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 1 output_log_all_processing.txt' ) ;
# conlts:
 system( 'sort ' . $option_t_space . ' -k1,1n output_prefixed_node_and_way_or_relation_pairs_all.txt -o output_sorted_node_and_way_or_relation_pairs.txt' ) ;
system( 'head -v output_sorted_node_and_way_or_relation_pairs.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'tail -v output_sorted_node_and_way_or_relation_pairs.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Verify that previously missing item IDs are in
#  the list of nodes for which latitudes and
#  longitudes will be found.

$grep_string_quoted = "'w330751369'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_sorted_node_and_way_or_relation_pairs.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;

$grep_string_quoted = "'n199650439'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_sorted_node_and_way_or_relation_pairs.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


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
#  Reminder:  This step runs for about two and a
#  half days.  (Or 7 hours with faster SSD PC.)
#
#  If the data in the binary files is the
#  shortened version for testing, then this
#  step will not take as long.
#
#  If needed for testing with a specific
#  segment of the data:
#  First, rename file to "__full" version, then:
#  system( 'grep "89044 w" output_sorted_node_and_way_or_relation_pairs__full.txt > output_sorted_node_and_way_or_relation_pairs.txt' ) ;
#  system( 'grep "96062 w" output_sorted_node_and_way_or_relation_pairs__full.txt >> output_sorted_node_and_way_or_relation_pairs.txt' ) ;


system( 'head -v output_sorted_node_and_way_or_relation_pairs.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

$grep_string_quoted = "'w330751369'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_sorted_node_and_way_or_relation_pairs.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -n 3 osm_merge_lats_lons_with_way_relation_ids.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl osm_merge_lats_lons_with_way_relation_ids.pl' ) ;
system( 'head -v output_outline_ways_relations_with_lats_lons.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Verify that some sample items were found.

$grep_string_quoted = "'w330751369'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_outline_ways_relations_with_lats_lons.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Use the Linux sort command to find the maximum
#  and minimum latitude and longitude for each way.

system( 'head -n 3 remove_column_three.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl remove_column_three.pl < output_outline_ways_relations_with_lats_lons.txt > output_way_or_relation_with_latitude.txt' ) ;
system( 'head -v output_way_or_relation_with_latitude.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -n 3 remove_column_two.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl remove_column_two.pl < output_outline_ways_relations_with_lats_lons.txt > output_way_or_relation_with_longitude.txt' ) ;
system( 'head -v output_way_or_relation_with_longitude.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'echo SORTING FILE >> output_log_all_processing.txt' ) ;
system( 'tail -n 1 output_log_all_processing.txt' ) ;
# conlts:
 system( 'sort ' . $option_t_space . ' -k1.2,1n -k2,2n output_way_or_relation_with_latitude.txt -o output_sorted_way_or_relation_with_latitude.txt' ) ;
system( 'head -v output_sorted_way_or_relation_with_latitude.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'echo SORTING FILE >> output_log_all_processing.txt' ) ;
system( 'tail -n 1 output_log_all_processing.txt' ) ;
# conlts:
 system( 'sort ' . $option_t_space . ' -k1.2,1n -k2,2n output_way_or_relation_with_longitude.txt -o output_sorted_way_or_relation_with_longitude.txt' ) ;
system( 'head -v output_sorted_way_or_relation_with_longitude.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Verify that specific way IDs now have the
#  latitudes and longitudes for the nodes along
#  that way.

$grep_string_quoted = "'w330751369'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_sorted_way_or_relation_with_latitude.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;

$grep_string_quoted = "'r181810'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_sorted_way_or_relation_with_latitude.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Calculate the bounding boxes for the ways.

system( 'head -n 3 osm_get_lat_lon_min_max.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl osm_get_lat_lon_min_max.pl' ) ;
system( 'head -v output_bounding_boxes_for_ways_and_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Verify specific information for debugging.

$grep_string_quoted = "'w330751369'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_bounding_boxes_for_ways_and_relations.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Use the gathered latitude and longitude info
#  to provide city center locations and business
#  center locations to the ways and relations.

system( 'head -v output_business_relation_info_without_extra_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_put_centers_into_city_or_biz_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_business_relation_info_without_extra_ways.txt > output_city_or_biz_info_needing_centers.txt' ) ;
# conlts:
 system( 'perl osm_put_centers_into_city_or_biz_info.pl' ) ;
# conlts:
 system( 'cat output_city_or_biz_info_with_centers.txt > output_biz_relation_info_with_centers.txt' ) ;
system( 'head -v output_biz_relation_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_log_put_centers_unrecognized.txt > output_log_put_centers_unrecognized_for_biz_relations.txt' ) ;
system( 'head -v output_log_put_centers_unrecognized_for_biz_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -v output_biz_way_info_tagged_as_biz.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_put_centers_into_city_or_biz_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_biz_way_info_tagged_as_biz.txt > output_city_or_biz_info_needing_centers.txt' ) ;
# conlts:
 system( 'perl osm_put_centers_into_city_or_biz_info.pl' ) ;
# conlts:
 system( 'cat output_city_or_biz_info_with_centers.txt > output_biz_way_info_with_centers.txt' ) ;
system( 'head -v output_biz_way_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_log_put_centers_unrecognized.txt > output_log_put_centers_unrecognized_for_biz_ways.txt' ) ;
system( 'head -v output_log_put_centers_unrecognized_for_biz_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -v output_city_relation_info_without_extra_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_put_centers_into_city_or_biz_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_city_relation_info_without_extra_ways.txt > output_city_or_biz_info_needing_centers.txt' ) ;
# conlts:
 system( 'perl osm_put_centers_into_city_or_biz_info.pl' ) ;
# conlts:
 system( 'cat output_city_or_biz_info_with_centers.txt > output_city_relation_info_with_centers.txt' ) ;
system( 'head -v output_city_relation_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_log_put_centers_unrecognized.txt > output_log_put_centers_unrecognized_for_city_relations.txt' ) ;
system( 'head -v output_log_put_centers_unrecognized_for_city_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -v output_city_way_info_tagged_as_city.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_put_centers_into_city_or_biz_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_city_way_info_tagged_as_city.txt > output_city_or_biz_info_needing_centers.txt' ) ;
# conlts:
 system( 'perl osm_put_centers_into_city_or_biz_info.pl' ) ;
# conlts:
 system( 'cat output_city_or_biz_info_with_centers.txt > output_city_way_info_with_centers.txt' ) ;
system( 'head -v output_city_way_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_log_put_centers_unrecognized.txt > output_log_put_centers_unrecognized_for_city_ways.txt' ) ;
system( 'head -v output_log_put_centers_unrecognized_for_city_ways.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Verify specific information for debugging.

$grep_string_quoted = "'r181810'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_city_relation_info_with_centers.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Get the info about nodes that are clearly
#  indicated as businesses or cities.  The cities
#  category includes townships, villages,
#  administrative boundaries (but not states),
#  etc.  This info has only a single location so
#  each node already has a "center" latitude and
#  longitude.

#  Reminder:  This step runs for probably two days.

system( 'cat no_content.txt > input_list_of_special_nodes_to_get.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_street_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_business_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_city_info.txt' ) ;
system( 'cat text_yes.txt > yes_or_no_get_node_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'head -n 3 osm_split_and_abbrev_node_way_relation.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#  Next line only needed for testing, and only if sample file was created:
# system( 'cat output_sample_nodes_xml.txt | perl osm_split_and_abbrev_node_way_relation.pl' ) ;


# conlts:
 system( 'bzcat planet-latest.osm.bz2 | perl osm_split_and_abbrev_node_way_relation.pl' ) ;


# conlts:
 system( 'cat output_business_node_info.txt > output_biz_node_info_with_prefix_b.txt' ) ;
system( 'head -v output_biz_node_info_with_prefix_b.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'cat output_city_node_info.txt > output_city_node_info_with_prefix_c.txt' ) ;
system( 'head -v output_city_node_info_with_prefix_c.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Remove from the business node info the letter
#  "b" at the beginning of each line so this info
#  matches the format of business way and
#  relation info.

system( 'head -n 3 remove_column_one.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl remove_column_one.pl < output_biz_node_info_with_prefix_b.txt > output_biz_node_info_with_centers.txt' ) ;
system( 'head -v output_biz_node_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Remove from the city node info the letter
#  "c" at the beginning of each line so this info
#  matches the format of city way and
#  relation info.

system( 'head -n 3 remove_column_one.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl remove_column_one.pl < output_city_node_info_with_prefix_c.txt > output_city_node_info_with_centers.txt' ) ;
system( 'head -v output_city_node_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Combine and process the info for business
#  relations, ways, and nodes.  Put the relations
#  first because usually they are more important.
#  Some nodes or ways refer to a shed or other
#  "outbuilding" that is located near the main
#  building and hopefully it is not named.

system( 'head -v output_biz_relation_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_biz_way_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_biz_node_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'cat output_biz_relation_info_with_centers.txt > output_business_info_all_nodes_ways_relations.txt' ) ;
# conlts:
 system( 'cat output_biz_way_info_with_centers.txt >> output_business_info_all_nodes_ways_relations.txt' ) ;
# conlts:
 system( 'cat output_biz_node_info_with_centers.txt >> output_business_info_all_nodes_ways_relations.txt' ) ;

system( 'head -v output_business_info_all_nodes_ways_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_handle_business_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'perl osm_handle_business_info.pl > output_log_osm_handle_business_info.txt' ) ;

system( 'head -v output_businesses_filtered.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_businesses_filtered_promo_type.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_log_osm_handle_business_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_business_frequency_count_exceeded.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Combine the info for city relations, ways and
#  nodes.  Put the relations last because some
#  relations are groups of nodes (or ways).

system( 'head -v output_city_node_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_city_way_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_city_relation_info_with_centers.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'cat output_city_node_info_with_centers.txt > output_city_info_all_nodes_ways_relations.txt' ) ;
# conlts:
 system( 'cat output_city_way_info_with_centers.txt >> output_city_info_all_nodes_ways_relations.txt' ) ;
# conlts:
 system( 'cat output_city_relation_info_with_centers.txt >> output_city_info_all_nodes_ways_relations.txt' ) ;


#-------------------------------------------------
#  Verify specific information for debugging.

$grep_string_quoted = "'r181810'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_city_info_all_nodes_ways_relations.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Process the info for city relations, ways and
#  nodes.  Also insert special entries to force
#  some special names and abbreviations for some
#  cities

system( 'head -v output_city_info_all_nodes_ways_relations.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 osm_handle_city_info.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'perl osm_handle_city_info.pl < output_city_info_all_nodes_ways_relations.txt' ) ;

system( 'head -n 20 -v output_processed_city_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_processed_country_codes.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_duplicate_city_names_searchable.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Verify specific information for debugging.

$grep_string_quoted = "'r181810'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_processed_city_info.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Sort the city info by ranking, which measures
#  importance, putting more important cities first
#  so that a search for "paris" finds
#  Paris France before Paris Texas.  Then remove
#  the sort rankings in the first column.
#
#  Do not remove duplicate city names because
#  they can be used as a neighborhood name within
#  a big city.  Example:  Hollywood district
#  within Portland Oregon.

system( 'head -v output_processed_city_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'echo SORTING FILE >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 1 output_log_all_processing.txt' ) ;
# conlts:
 system( 'sort ' . $option_t_space . ' -k1,1nr output_processed_city_info.txt -o output_sorted_processed_city_info.txt' ) ;

system( 'head -v output_sorted_processed_city_info.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 remove_column_one.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# The next command must be run again if the later optional postal-code processing overwrites the "output_city_info_ready_to_split" file.
# conlts:
 system( 'perl remove_column_one.pl < output_sorted_processed_city_info.txt > output_city_info_ready_to_split.txt' ) ;

system( 'head -v output_city_info_ready_to_split.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Verify specific information for debugging.

$grep_string_quoted = "'r181810'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_city_info_ready_to_split.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Generate a density map of the cities.
#  This provides verification of the data.

system( 'head -n 3 remove_column_one.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'perl remove_column_one.pl < output_city_info_ready_to_split.txt | perl remove_column_one.pl | perl remove_column_one.pl > output_density_mapable_lats_lons.txt' ) ;

system( 'head -v output_density_mapable_lats_lons.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 generate_map_density_squares.pl >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl generate_map_density_squares.pl < output_density_mapable_lats_lons.txt > output_map_density_squares.txt' ) ;
# conlts:
 system( 'cat map_image_begin.txt > map_full_cities.svg' ) ;
# conlts:
 system( 'cat output_map_density_squares.txt >> map_full_cities.svg' ) ;
# conlts:
 system( 'cat map_image_end.txt >> map_full_cities.svg' ) ;
system( 'ls map_full_cities.svg >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Generate a density map of the businesses, but
#  exclude the ones that are not shown unless
#  they are promoted.  This map provides
#  verification of the data.

system( 'head -n 3 remove_column_one.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl remove_column_one.pl < output_businesses_filtered.txt > output_density_mapable_lats_lons.txt' ) ;
system( 'head -v output_density_mapable_lats_lons.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 generate_map_density_squares.pl >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'perl generate_map_density_squares.pl < output_density_mapable_lats_lons.txt > output_map_density_squares.txt' ) ;
# conlts:
 system( 'cat map_image_begin.txt > map_full_businesses.svg' ) ;
# conlts:
 system( 'cat output_map_density_squares.txt >> map_full_businesses.svg' ) ;
# conlts:
 system( 'cat map_image_end.txt >> map_full_businesses.svg' ) ;
system( 'ls -l map_full_businesses.svg >> output_log_businesses_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Split the two processed business files into
#  multiple files in two new folders.

system( 'head -v output_businesses_filtered.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 split_on_server.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# do NOT change the "rm" command without careful testing!
# conlts:
 system( 'rm -rf businesses_new' ) ;

# conlts:
 system( 'perl split_on_server.pl < output_businesses_filtered.txt' ) ;

# do NOT change the "rm" command without careful testing!
# conlts:
 system( 'rm -rf businesses_new_filtered' ) ;

# conlts:
 system( 'mv businesses_new businesses_new_filtered' ) ;

system( 'head -v businesses_new_filtered/lat9_1045/businesses_category_1045_0877.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

system( 'head -v output_businesses_filtered_promo_type.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 split_on_server.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# do NOT change the "rm" command without careful testing!
# conlts:
 system( 'rm -rf businesses_new_promo' ) ;

# conlts:
 system( 'perl split_on_server.pl < output_businesses_filtered_promo_type.txt' ) ;

# conlts:
 system( 'mv businesses_new businesses_new_promo' ) ;

system( 'head -v businesses_new_promo/lat9_1045/businesses_category_1045_0877.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Optional:  Use non-OSM postal code data to
#  supply state and province abbreviations to the
#  city info.
#
#  To skip this section, comment-out these
#  lines of code.
#
#  The comments in the script
#  "convert_postal_code_database.pl" explain
#  where to get the postal code data.
#
#  Reminder: The code in this section uses the
#  same filename --
#  "output_city_info_ready_to_split" for both
#  input and output so use care when editing
#  this section.

system( 'echo OPTIONAL POSTAL CODE PROCESSING >> output_log_all_processing.txt' ) ;
system( 'tail -n 1 output_log_all_processing.txt' ) ;
system( 'cat output_city_info_ready_to_split.txt > output_city_info_ready_to_split_before_postal_processing.txt' ) ;
# conlts:
 system( 'perl convert_tab_delimited_to_quoted_csv.pl < PostalCodesAllCountriesLatest.txt > output_postal_code_info_csv_format.txt' ) ;
# conlts:
 system( 'perl convert_postal_code_database.pl < output_postal_code_info_csv_format.txt' ) ;
# conlts:
 system( 'perl merge_city_info_from_postal_into_osm.pl < output_city_info_ready_to_split_before_postal_processing.txt > output_city_info_with_state_province_codes.txt' ) ;
# conlts:
 system( 'cat output_city_info_with_state_province_codes.txt > output_city_info_ready_to_split.txt' ) ;


#-------------------------------------------------
#  Verify specific information for debugging.

$grep_string_quoted = "'kent_oh'" ;
# conlts:
 system( 'echo GREP CHECK ' . $grep_string_quoted . ' >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'grep ' . $grep_string_quoted . ' output_city_info_ready_to_split.txt >> output_log_all_processing.txt' ) ;
# conlts:
 system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Split the processed city file into multiple
#  files and put those files into a new folder.

system( 'head -v output_city_info_ready_to_split.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -n 3 split_on_server.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# do NOT change the "rm" command without careful testing!
# conlts:
 system( 'rm -rf cities_new' ) ;

# conlts:
 system( 'perl split_on_server.pl < output_city_info_ready_to_split.txt' ) ;

system( 'head -v cities_new/cities_category_prt.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Create versions of the result files that use
#  standard decimal signed numbers for latitude
#  and longitude.

system( 'head -n 3 osm_convert_lats_lons_to_decimal.pl >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;

# conlts:
 system( 'perl osm_convert_lats_lons_to_decimal.pl < output_city_info_ready_to_split.txt > output_city_info_ready_to_split_decimal.txt' ) ;
# conlts:
 system( 'perl osm_convert_lats_lons_to_decimal.pl < output_businesses_filtered.txt > output_businesses_filtered_decimal.txt' ) ;
# conlts:
 system( 'perl osm_convert_lats_lons_to_decimal.pl < output_businesses_filtered_promo_type.txt > output_businesses_filtered_promo_type_decimal.txt' ) ;

system( 'head -v output_city_info_ready_to_split_decimal.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_businesses_filtered_decimal.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;
system( 'head -v output_businesses_filtered_promo_type_decimal.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Show the file sizes.

system( 'ls -sSr output_*.txt >> output_log_all_processing.txt' ) ;
system( 'tail -n 3 output_log_all_processing.txt' ) ;


#-------------------------------------------------
#  Display instructions for what to do next, which
#  is to compress the data, upload it to the
#  server, then uncompress it.

print "\n\n" . "Do next:  Use the cd command to enter the new folders and execute the following command (including the period at the end), with 'city' instead of 'business' as needed:" . "\n" ;

print "  zip -r -q uploadable_business_info_zipped.zip ." . "\n" ;

print "\n" . "Then upload the created zip files to the server into new folders with the same names and unzip each file using the following command" . "\n" ;

print "  unzip uploadable_business_info_zipped.zip" . "\n" ;


#-------------------------------------------------
#  All done handling cities and businesses.

