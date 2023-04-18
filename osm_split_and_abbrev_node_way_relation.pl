#--------------------------------------------------
#       osm_split_and_abbrev_node_way_relation.pl
#--------------------------------------------------

#  (c) Copyright 2014-2023 by Richard Fobes at SolutionsCreative.com
#  Permission to copy and use and modify this
#  software is hereby given to individuals and to
#  businesses with ten or fewer employees if this
#  copyright notice is included in all copies
#  and modified copies.
#  All other rights are reserved.
#  Businesses with more than ten employees are
#  encouraged to contract with small businesses
#  to supply the service of running this software
#  if they also arrange to make donations to
#  support the Open Street Map project.


#--------------------------------------------------
#  Processes XML data file planet-latest.osm.bz from:
#  https://ftp.osuosl.org/pub/openstreetmap/planet
#
#
#  For usage, see perl script:  osm_processing_do_all.pl
#
#  Notes:
#  Output to terminal shows progress indicator, so
#  do not redirect standard output.  To run a shell
#  script in Ubuntu, open the "Terminal" app and
#  use "cd" command to change to directory that
#  contains the data and scripts, then enter "bash"
#  followed by the full name of the shell script.
#  In second "Terminal" run "top" Linux command to
#  monitor CPU & memory usage.  When entering
#  filenames and directories, use Tab key for
#  auto-completion.
#
#
#--------------------------------------------------
#  Define the yes and no constants -- as numbers.

$yes_yes = 1 + 0 ;
$no_no = 0 + 0 ;


#--------------------------------------------------
#  Specify which data is being extracted.

$yes_or_no_get_street_info = $no_no ;
$yes_or_no_get_business_info = $no_no ;
$yes_or_no_get_city_info = $no_no ;
$yes_or_no_get_node_info = $no_no ;
$yes_or_no_get_way_info = $no_no ;
$yes_or_no_get_relation_info = $no_no ;

open( INFILE , "<" . "yes_or_no_get_street_info.txt" ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    print "yes_or_no_get_street_info: " ;
    if ( $input_line =~ /yes/ )
    {
        $yes_or_no_get_street_info = $yes_yes ;
        print "yes" ;
    } else
    {
        print "no" ;
    }
    print "\n" ;
    last ;
}
close( INFILE ) ;

open( INFILE , "<" . "yes_or_no_get_business_info.txt" ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    print "yes_or_no_get_business_info: " ;
    if ( $input_line =~ /yes/ )
    {
        $yes_or_no_get_business_info = $yes_yes ;
        print "yes" ;
    } else
    {
        print "no" ;
    }
    print "\n" ;
    last ;
}
close( INFILE ) ;

open( INFILE , "<" . "yes_or_no_get_city_info.txt" ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    print "yes_or_no_get_city_info: " ;
    if ( $input_line =~ /yes/ )
    {
        $yes_or_no_get_city_info = $yes_yes ;
        print "yes" ;
    } else
    {
        print "no" ;
    }
    print "\n" ;
    last ;
}
close( INFILE ) ;

open( INFILE , "<" . "yes_or_no_get_node_info.txt" ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    print "yes_or_no_get_node_info: " ;
    if ( $input_line =~ /yes/ )
    {
        $yes_or_no_get_node_info = $yes_yes ;
        print "yes" ;
    } else
    {
        print "no" ;
    }
    print "\n" ;
    last ;
}
close( INFILE ) ;

open( INFILE , "<" . "yes_or_no_get_way_info.txt" ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    print "yes_or_no_get_way_info: " ;
    if ( $input_line =~ /yes/ )
    {
        $yes_or_no_get_way_info = $yes_yes ;
        print "yes" ;
    } else
    {
        print "no" ;
    }
    print "\n" ;
    last ;
}
close( INFILE ) ;

open( INFILE , "<" . "yes_or_no_get_relation_info.txt" ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    print "yes_or_no_get_relation_info: " ;
    if ( $input_line =~ /yes/ )
    {
        $yes_or_no_get_relation_info = $yes_yes ;
        print "yes" ;
    } else
    {
        print "no" ;
    }
    print "\n" ;
    last ;
}
close( INFILE ) ;


#--------------------------------------------------
#  Specify Linux or Windows path style.

# $slash_or_backslash = "\\" ;  # windows
$slash_or_backslash = "/" ;  # linux


#---------------------------------------------------
#  If requested, get the list of any way IDs of
#  interest.

$file_name_list_of_way_ids = "input_list_of_special_ways_to_get.txt" ;
open( INFILE , "<" . $file_name_list_of_way_ids ) ;
$count_of_ways_needed = 0 ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    if ( ( $input_line =~ /(w[0-9]+)/ ) && ( $yes_or_no_get_way_info == $yes_yes ) )
    {
        $node_way_id = $1 ;
        $need_way_id{ $node_way_id } = "y" ;
        $count_of_ways_needed ++ ;
    }
}
close( INFILE ) ;
print "will get info for " . $count_of_ways_needed . " listed way IDs" . "\n" ;


#--------------------------------------------------
#  Specify file path prefix.

$optional_prefix_path_for_output = "" ;


#--------------------------------------------------
#  Create the output log file.

open( OUT_LOG , ">" . $optional_prefix_path_for_output . 'output_log_split_node_way_relation.txt' ) ;


#---------------------------------------------------
#  If any way IDs are specifically requested, open
#  an output file for writing the links info for
#  those ways.
#  The other output files are opened when they are
#  first needed.

if ( $count_of_ways_needed > 0 )
{
    open( OUT_LINKS , ">" . $optional_prefix_path_for_output . 'output_info_for_listed_ways.txt' ) ;
}


#--------------------------------------------------
#  Indicate business tags of interest.

$info_type_from_tag_and_value{ "amenity_restaurant" } = "business" ;
$info_type_from_tag_and_value{ "amenity_cafe" } = "business" ;
$info_type_from_tag_and_value{ "shop_bakery" } = "business" ;
$info_type_from_tag_and_value{ "shop_cheeze" } = "business" ;
$info_type_from_tag_and_value{ "shop_deli" } = "business" ;
$info_type_from_tag_and_value{ "shop_tea" } = "business" ;
$info_type_from_tag_and_value{ "shop_coffee" } = "business" ;
$info_type_from_tag_and_value{ "shop_confectionery" } = "business" ;
$info_type_from_tag_and_value{ "amenity_ice_cream" } = "business" ;
$info_type_from_tag_and_value{ "shop_antiques" } = "business" ;
$info_type_from_tag_and_value{ "shop_art" } = "business" ;
$info_type_from_tag_and_value{ "shop_music" } = "business" ;
$info_type_from_tag_and_value{ "shop_musical_instrument" } = "business" ;
$info_type_from_tag_and_value{ "shop_books" } = "business" ;
$info_type_from_tag_and_value{ "shop_toys" } = "business" ;
$info_type_from_tag_and_value{ "shop_car_repair" } = "business" ;
$info_type_from_tag_and_value{ "shop_hardware" } = "business" ;
$info_type_from_tag_and_value{ "shop_doityourself" } = "business" ;
$info_type_from_tag_and_value{ "amenity_dentist" } = "business" ;
$info_type_from_tag_and_value{ "amenity_biergarten" } = "business" ;


#--------------------------------------------------
#  Indicate city tags of interest.
#  Also get country (nation) info.
#
#  The "is_in" data is not reliable as a source of
#  naming the country in which the city is located.
#  (It is missing for many cities.)
#  The data designers assume that this information
#  can be derived by determining which country's
#  borders the city is within.
#
#  The two-letter country codes are not used in
#  all city nodes and ways and relations, so
#  instead, if multiple cities have the same
#  matching name (during a user search),
#  choose the city that is closest to the center
#  of the indicated (with the two-letter
#  abbreviation) nation.
#  Note:  The relation for France includes
#  territories such as French Polynesia, so
#  use the label node location, or the admin_centre
#  node location, or an average between the two.
#
#  The tag "admin_level" is explicitly searched for.
#  It has different meanings for different countries.
#  Documented at URL:
#    http://wiki.openstreetmap.org/wiki/Key:admin_level#admin_level
#
#  If the item is a building then it cannot be a
#  city, and instead is probably something like a
#  city hall.

$info_type_from_tag{ "population" } = "city" ;
$info_type_from_tag{ "ISO3166-1:alpha2" } = "city" ;
$info_type_from_tag{ "admin_centre" } = "city" ;

$info_type_from_tag_and_value{ "boundary_administrative" } = "city" ;

$info_type_from_tag_and_value{ "border_type_city" } = "city" ;
$info_type_from_tag_and_value{ "border_type_township" } = "city" ;
$info_type_from_tag_and_value{ "border_type_village" } = "city" ;

$info_type_from_tag_and_value{ "boundary_type_city" } = "city" ;
$info_type_from_tag_and_value{ "boundary_type_town" } = "city" ;

$info_type_from_tag_and_value{ "place_city" } = "city" ;
$info_type_from_tag_and_value{ "place_town" } = "city" ;
$info_type_from_tag_and_value{ "place_village" } = "city" ;
$info_type_from_tag_and_value{ "place_hamlet" } = "city" ;
$info_type_from_tag_and_value{ "place_suburb" } = "city" ;
$info_type_from_tag_and_value{ "place_municipality" } = "city" ;
$info_type_from_tag_and_value{ "place_borough" } = "city" ;
$info_type_from_tag_and_value{ "place_quarter" } = "city" ;
#  British spelling of "neighbourhood" is correct.
$info_type_from_tag_and_value{ "place_neighbourhood" } = "city" ;

#  place=locality is not a good tag for places with people living there,
#  but it is sometimes used for that purpose, so allow:
#  $info_type_from_tag_and_value{ "place_locality" } = "ignore" ;

#  An island (such as Staten Island) can be used as a
#  location, so allow it:
#  $info_type_from_tag_and_value{ "place_island" } = "ignore" ;

$info_type_from_tag_and_value{ "building_government" } = "ignore" ;


#--------------------------------------------------
#  Indicate street tags of interest.

$info_type_from_tag{ "highway" } = "street" ;
$info_type_from_tag{ "motorway" } = "street" ;
$info_type_from_tag{ "tiger:name_type" } = "street" ;
# $info_type_from_tag{ "route" } = "street" ;

$info_type_from_tag_and_value{ "route_road" } = "street" ;

#  Ignore a "highway_path" because it is more of a
#  path than a highway:
$info_type_from_tag_and_value{ "highway_path" } = "ignore" ;

$info_type_from_tag_and_value{ "route_railway" } = "ignore" ;
$info_type_from_tag_and_value{ "route_train" } = "ignore" ;
$info_type_from_tag_and_value{ "route_ferry" } = "ignore" ;
$info_type_from_tag_and_value{ "amenity_parking" } = "ignore" ;

#  Other exclusions for "bicycle", "bus", "hiking",
#  "ski", "piste", "trail", "subway", "mtb" etc.
#  are handled later to avoid excluding a "bicycle" route
#  or "snowmobile" route that is along the same "way" as
#  a road for vehicles.
#
#  "mtb" = "mountain-bike"
#  "piste" is a bobsled route


#--------------------------------------------------
#  Initialization.

$latitude = "" ;
$name_info = "" ;
$alternate_name_info = "" ;
$city_tag_info = "" ;
$street_tag_info = "" ;
$business_tag_info = "" ;
$business_web_info = "" ;
$linked_ids = "" ;
$label_at_info = "" ;
$count_of_foreign_lang_names = 0 ;
$is_in_tag_info = "" ;

$no_data_category = 0 + 0 ;
$node_data_category = 1 + 0 ;
$way_data_category = 2 + 0 ;
$relation_data_category = 3 + 0 ;
$category_of_data = $no_data_category ;
$previous_category_of_data = $no_data_category ;

$node_count = 0 ;
$way_count = 0 ;
$relation_count = 0 ;

$progress_counter = 0 ;

$zero_digits_of_count[ 0 ] = "" ;
$zero_digits_of_count[ 1 ] = "0" ;
$zero_digits_of_count[ 2 ] = "00" ;
$zero_digits_of_count[ 3 ] = "000" ;
$zero_digits_of_count[ 4 ] = "0000" ;
$zero_digits_of_count[ 5 ] = "00000" ;
$zero_digits_of_count[ 6 ] = "000000" ;
$zero_digits_of_count[ 7 ] = "0000000" ;
$zero_digits_of_count[ 8 ] = "00000000" ;
$zero_digits_of_count[ 9 ] = "000000000" ;
$zero_digits_of_count[ 10 ] = "0000000000" ;
$zero_digits_of_count[ 11 ] = "00000000000" ;
$nine_digits_of_count[ 0 ] = "" ;
$nine_digits_of_count[ 1 ] = "9" ;
$nine_digits_of_count[ 2 ] = "99" ;
$nine_digits_of_count[ 3 ] = "999" ;
$nine_digits_of_count[ 4 ] = "9999" ;
$nine_digits_of_count[ 5 ] = "99999" ;
$nine_digits_of_count[ 6 ] = "999999" ;
$nine_digits_of_count[ 7 ] = "9999999" ;
$nine_digits_of_count[ 8 ] = "99999999" ;
$nine_digits_of_count[ 9 ] = "999999999" ;
$nine_digits_of_count[ 10 ] = "9999999999" ;
$nine_digits_of_count[ 11 ] = "99999999999" ;


#--------------------------------------------------
#  Read each line in the file.
#  Replace any tab, newline, or carriage return
#  with a space.  Then omit adjacent spaces.
#  Later code assumes there are never two or
#  more adjacent spaces.

$line_number = 0 ;
while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    $input_line =~ s/[\n\r\t]+/ /sg ;
    $input_line =~ s/  +/ /sg ;
    $line_number ++ ;


#--------------------------------------------------
#  Uncomment this code if need to view segment of
#  input file for debugging purposes.
#
#  This code was used to discover that the
#  following data mistakenly specified that the
#  official_name for Canada is "Isle of Man":
#
#     <tag k="int_name" v="Canada" />
#     <tag k="official_name" v="Isle of Man" />
#     <tag k="ISO3166-1" v="ca" />
#     <tag k="name" v="Canada" />
#
#  Also it was used to find a missing slash at
#  the end of some node lines such as:
#
#     <node id="9483616092" lat="33.7108732" lon="-91.4542551" timestamp="2022-02-06T15:19:39Z" version="1" changeset="117082988" user="1T-money" uid="3715012">

#    if ( $input_line =~ /"9483616/ )
#    {
#        print OUT_LOG "line number " . $line_number . "\n" ;
#        print OUT_LOG $input_line . "\n" ;
#        while( $input_line = <INFILE> )
#        {
#            chomp( $input_line ) ;
#            $input_line =~ s/[\n\r\t]/ /sg ;
#            $input_line =~ s/  +/ /g ;
#            print OUT_LOG $input_line . "\n" ;
#            if ( $input_line =~ /<node/ )
#            {
#                last ;
#            }
#        }
#    }
#    next ;


#--------------------------------------------------
#  If the line begins a new node, way, or relation
#  and the previous node, way, or relation info has
#  not yet been written, write the collected info.
#  Also clear the collected info.
#
#  This code would not be needed if ALL the OSM
#  data was in standard XML format!  However,
#  the ending slash is missing from some OSM node
#  data!

    if ( ( $node_or_way_or_relation_id ne "" ) && ( $input_line =~ /^ ?<((node)|(way)|(relation)) ?[^\/]?> ?$/ ) )
    {
        &write_info( ) ;
    }


#--------------------------------------------------
#  Handle the beginning of a node, way, or
#  relation.
#
#  Reminder:  The OSM data includes an editor's
#  user ID indicated as "uid=" so the space before
#  "id=" is important to recognize.

    if ( $input_line =~ /^ *<node id="([0-9]+)".* lat="([\-0-9\.]+)".* lon="([\-0-9\.]+)"/ )
    {
        $node_id_number_only = $1 ;
        $latitude = $2 ;
        $longitude = $3 ;
        $node_id = "n" . $node_id_number_only ;
        $category_of_data = $node_data_category ;
        $node_or_way_or_relation_id = $node_id ;
        $node_count ++ ;
    } elsif ( $input_line =~ /^ *<node id="([0-9]+)"/ )
    {
        $node_id_number_only = $1 ;
        $latitude = "" ;
        $longitude = "" ;
        $node_id = "n" . $node_id_number_only ;
        $category_of_data = $node_data_category ;
        $node_or_way_or_relation_id = $node_id ;
        $node_count ++ ;
    } elsif ( $input_line =~ /^ *<way id="([0-9]+)"/ )
    {
        $way_id_number_only = $1 ;
        $way_id = "w" . $way_id_number_only ;
        $category_of_data = $way_data_category ;
        $node_or_way_or_relation_id = $way_id ;
        $way_count ++ ;
    } elsif ( $input_line =~ /^ *<relation id="([0-9]+)"/ )
    {
        $relation_id_number_only = $1 ;
        $relation_id = "r" . $relation_id_number_only ;
        $category_of_data = $relation_data_category ;
        $node_or_way_or_relation_id = $relation_id ;
        $relation_count ++ ;
    } elsif ( $input_line =~ /^ *<relation / )
    {
        $relation_id_number_only = "???" ;
        $relation_id = "r" . $relation_id_number_only ;
        $category_of_data = $relation_data_category ;
        $node_or_way_or_relation_id = $relation_id ;
        $relation_count ++ ;
    }


#--------------------------------------------------
#  Get a latitude or longitude that is on a
#  separate line.

    if ( ( $category_of_data == $node_data_category ) && ( $input_line =~ /lat="([\-0-9\.]+)".* lon="([\-0-9\.]+)"/ ) )
    {
        $latitude = $1 ;
        $longitude = $2 ;
    } elsif ( ( $category_of_data == $node_data_category ) && ( $input_line =~ /lat="([\-0-9\.]+)"/ ) )
    {
        $latitude = $1 ;
    } elsif ( ( $category_of_data == $node_data_category ) && ( $input_line =~ /lon="([\-0-9\.]+)"/ ) )
    {
        $longitude = $1 ;


#--------------------------------------------------
#  If a subordinate item is a label for the item,
#  then save that label's item ID.

    } elsif ( ( $category_of_data == $way_data_category ) && ( $input_line =~ /^ *<nd ref="([0-9]+)"/ ) )
    {
        $node_id_number_only = $1 ;
        $node_id = "n" . $node_id_number_only ;
        if ( $input_line =~ / role="label"/ )
        {
            $label_at_info = "label_at_" . $node_id ;
        } else
        {
            $linked_ids .= $node_id . "_" ;
        }


#--------------------------------------------------
#  Get info about a link between a way and node,
#  or between a relation and way, or between
#  a relation and node.

    } elsif ( $input_line =~ /<member / )
    {
        if ( $input_line =~ /<member type="way" ref="([0-9]+)"/ )
        {
            $id_number_only = $1 ;
            $linked_ids .= "w" . $id_number_only . "_" ;
        }
        if ( $input_line =~ /<member type="node" ref="([0-9]+)"/ )
        {
            $id_number_only = $1 ;
            if ( $input_line =~ / role="((label)|(admin_centre))"/ )
            {
                $label_at_info = "label_at_n" . $id_number_only ;
            } else
            {
                $linked_ids .= "n" . $id_number_only . "_" ;
            }
        }
    }


#--------------------------------------------------
#  At the end of a node, way, or relation, write
#  the collected node, way, or relation
#  information.  Also clear the collected info.
#  Allow for the node info to be on just a single
#  line.
#
#  Reminder:  Node and way data usually spans
#  multiple lines.
#
#  Reminder:  Some OSM XML data is missing the
#  XML-required slash at the end of a node, so
#  some earlier code has to handle those cases.

    if ( ( $input_line =~ /<\/ ?((node)|(way)|(relation))[^>]*>/ ) || ( $input_line =~ /<((node)|(way)|(relation))[^>]*\/> ?$/ ) )
    {
        &write_info( ) ;


#--------------------------------------------------
#  After writing info, possibly show progress.

        if ( $progress_counter > 500000 )
        {
            if ( $category_of_data == $relation_data_category )
            {
                $log_info = " r " . " b " . $collection_count_biz_relation . " c " . $collection_count_city_relation . " s " . $collection_count_street_relation ;
            } elsif ( $category_of_data == $way_data_category )
            {
                $log_info = " w " . " b " . $collection_count_biz_way . " c " . $collection_count_city_way . " s " . $collection_count_street_way . " m " . $collection_count_way_matches ;
            } elsif ( $category_of_data == $node_data_category )
            {
                $log_info = " n " . " b " . $collection_count_biz_node . " c " . $collection_count_city_node . " s " . $collection_count_street_node . " m " . $collection_count_node_matches ;
            } else
            {
                $log_info = " category unknown " . $collection_count_node_uncategorized ;
            }
            print $log_info . "\n" ;
            print OUT_LOG $log_info . "\n" ;
            $progress_counter = 0 ;
        }
        $progress_counter ++ ;


#--------------------------------------------------
#  Identify transitions, between nodes and ways and
#  relations.
#  Actually, this code identifies the time just after
#  a transition has occurred, such that one item
#  in the new category may have been written.
#  At these transitions close files that no longer
#  need to be kept open.
#  Also exit the main loop if the next data type
#  is not of interest.
#  If node and relation data are requested without
#  also requesting way info, ignore the relation
#  data.

        if ( $category_of_data != $previous_category_of_data )
        {
            print "progressing to next data type " . "\n" ;
            if ( ( $previous_category_of_data == $node_data_category ) && ( $yes_or_no_get_node_info == $yes_yes ) )
            {
                if ( $yes_or_no_get_business_info == $yes_yes )
                {
                    close( BIZ_NODE_FILE ) ;
                }
                if ( $yes_or_no_get_city_info == $yes_yes )
                {
                    close( CITY_NODE_FILE ) ;
                }
            }
            if ( ( $previous_category_of_data == $way_data_category ) && ( $yes_or_no_get_way_info == $yes_yes ) )
            {
                if ( $yes_or_no_get_business_info == $yes_yes )
                {
                    close( BIZ_WAY_FILE ) ;
                }
                if ( $yes_or_no_get_city_info == $yes_yes )
                {
                    close( CITY_WAY_FILE ) ;
                }
                if ( $yes_or_no_get_street_info == $yes_yes )
                {
                    close( STREET_WAY_FILE ) ;
                }
            }
            if ( ( $category_of_data == $way_data_category ) && ( $yes_or_no_get_way_info == $no_no ) && ( $count_of_ways_needed < 1 ) )
            {
                last ;
            }
            if ( ( $category_of_data == $relation_data_category ) && ( $yes_or_no_get_relation_info == $no_no ) )
            {
                last ;
            }
        }
        $previous_category_of_data = $category_of_data ;


#--------------------------------------------------
#  If not at the end of a node, way, or relation,
#  get any tag and value information.
#  Handle data of interest for either node, way,
#  or relation type.
#
#  Do not write nodes and ways and relations
#  that are definitely not of interest.
#  Maritime boundaries are not of interest.
#  A "southbound" node is a bus stop, not a street entity,
#  so it is not of interest.
#
#  When looking at relation data, a route type of
#  "road" is of interest, but all other route
#  types -- e.g. route_bicycle -- are not of
#  interest.

    } elsif ( $input_line =~ /<tag k="([^"]+)" v="([^"]+)"/ )
    {
        $tag = $1 ;
        $value = $2 ;
        $tag_and_value = $tag . "_" . $value ;
        if ( ( $tag_and_value eq "maritime_yes" ) || ( ( $category_of_data == $node_data_category ) && ( $value =~ /((north)|(south)|(east)|(west))bound/ ) ) )
        {
            $city_tag_info = "" ;
            $street_tag_info = "" ;
        } elsif ( ( ( $tag eq "route" ) || ( $tag eq "highway" ) ) && ( exists( $route_type_of_no_interest{ $value } ) ) )
        {
            $street_tag_info = "" ;
        } elsif ( $tag eq "admin_level" )
        {
            if ( $yes_or_no_get_city_info == $yes_yes )
            {
                $city_tag_info .= $tag_and_value . " " ;
            }
        } elsif ( exists( $info_type_from_tag_and_value{ $tag_and_value } ) )
        {
            if ( $info_type_from_tag_and_value{ $tag_and_value } eq "business" )
            {
                if ( $yes_or_no_get_business_info == $yes_yes )
                {
                    $business_tag_info .= $tag_and_value . " " ;
                }
            } elsif ( $info_type_from_tag_and_value{ $tag_and_value } eq "city" )
            {
                if ( $yes_or_no_get_city_info == $yes_yes )
                {
                    $city_tag_info .= $tag_and_value . " " ;
                }
            } elsif ( $info_type_from_tag_and_value{ $tag_and_value } eq "street" )
            {
                if ( $yes_or_no_get_street_info == $yes_yes )
                {
                    $street_tag_info .= $tag_and_value . " " ;
                }
            } elsif ( $info_type_from_tag_and_value{ $tag_and_value } eq "ignore" )
            {
                $business_tag_info = "" ;
                $city_tag_info = "" ;
                $street_tag_info = "" ;
            }
        } elsif ( exists( $info_type_from_tag{ $tag } ) )
        {
            $value_without_spaces = $value ;
            if ( $value_without_spaces =~ / / )
            {
                $value_without_spaces =~ s/\([^\)]+\)/ / ;
                $value_without_spaces =~ s/  +/ / ;
                $value_without_spaces =~ s/^ // ;
                $value_without_spaces =~ s/ $// ;
                $value_without_spaces =~ s/ /_/g ;
            }
            if ( $info_type_from_tag{ $tag } eq "business" )
            {
                if ( $yes_or_no_get_business_info == $yes_yes )
                {
                    $business_tag_info .= $tag . "_" . $value_without_spaces . " " ;
                }
            } elsif ( $info_type_from_tag{ $tag } eq "city" )
            {
                if ( ( $yes_or_no_get_city_info == $yes_yes ) && ( $value_without_spaces ne "" ) )
                {
                    if ( ( $tag eq "population" ) && ( $value !~ /^[0-9]+$/ ) )
                    {
                        $ignored_count_of_invalid_population_values ++ ;
                    } else
                    {
                        $city_tag_info .= $tag . "_" . $value_without_spaces . " " ;
                    }
                }
            } elsif ( ( $category_of_data == $relation_data_category ) && ( $tag eq "route" ) && ( $tag_and_value ne "route_road" ) )
            {
                $street_tag_info = "" ;
            } elsif ( $info_type_from_tag{ $tag } eq "street" )
            {
                if ( $yes_or_no_get_street_info == $yes_yes )
                {
                    $street_tag_info .= $tag . "_" . $value_without_spaces . " " ;
                }
            } elsif ( $info_type_from_tag{ $tag } eq "ignore" )
            {
                $business_tag_info = "" ;
                $city_tag_info = "" ;
                $street_tag_info = "" ;
            }
        } elsif ( $tag eq "name" )
        {
            $value =~ s/\([^\)]+\)/ / ;
            $value =~ s/  +/ / ;
            $value =~ s/^ // ;
            $value =~ s/ $// ;
            $value =~ s/ /_/g ;
            $name_info = $value ;
        } elsif ( $tag =~ /^name:[a-z][a-z]/ )
        {
            $count_of_foreign_lang_names ++ ;
            if ( $tag eq "name:en" )
            {
                if ( ( $value =~ /[a-z]/ ) || ( $value !~ /[A-Z]/ ) )
                {
                    $value =~ s/\([^\)]+\)/ / ;
                    $value =~ s/  +/ / ;
                    $value =~ s/^ // ;
                    $value =~ s/ $// ;
                    $value =~ s/ /_/g ;
                    $alternate_name_info .= $tag . "_" . $value . " " ;
                }
            }
        } elsif ( ( $tag eq "alt_name" ) || ( $tag eq "official_name" ) || ( $tag eq "int_name" ) )
        {
            $value =~ s/\([^\)]+\)/ / ;
            $value =~ s/  +/ / ;
            $value =~ s/^ // ;
            $value =~ s/ $// ;
            $value =~ s/ /_/g ;
            $alternate_name_info .= $tag . "_" . $value . " " ;
        } elsif ( ( $tag eq "website" ) && ( $yes_or_no_get_business_info == $yes_yes ) )
        {
#  allow for http and https
            $value =~ s/https?:\/\/// ;
            $value =~ s/https?:\/\/// ;
            $value =~ s/[\/\\]+$// ;
            $value =~ s/^ // ;
            $value =~ s/ $// ;
            if ( $value !~ / / )
            {
                $business_web_info = $value ;
            }
        } elsif ( ( $tag =~ /^is_in:/ ) && ( $yes_or_no_get_city_info == $yes_yes ) && ( $tag !~ /^is_in:((continent)|(city))/ ) && ( $value ne "Canada" ) && ( $value ne "USA" ) && ( $value ne "United States of America" ) )
        {
            $value =~ s/:/ /g ;
            $value =~ s/\(/ /g ;
            $value =~ s/\)/ /g ;
            $value =~ s/  +/ /g ;
            $value =~ s/^ // ;
            $value =~ s/ $// ;
            $value =~ s/ /_/g ;
            $is_in_tag_info .= $tag . "_" . $value . " " ;
        } elsif ( ( $yes_or_no_get_city_info == $yes_yes ) && ( $tag =~ /^ISO3166/ ) && ( $value =~ /^[a-z][a-z]$/i ) )
        {
            $value = lc( $value ) ;
            $city_tag_info .= "country_code_" . $value . " " ;
        }
    }


#--------------------------------------------------
#  Repeat the loop to handle the next line.

}


#--------------------------------------------------
#  If there is an item waiting to be written,
#  write it.

&write_info( ) ;


#--------------------------------------------------
#  All done.

exit ;


#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#
#  Subroutine:
#
#  write_info
#
#--------------------------------------------------
#  Write the info for one node, way, or relation.

#--------------------------------------------------

sub write_info
{


#--------------------------------------------------
#  Check whether the current way ID matches one of
#  the way IDs specifically being requested.  If
#  there is a match, write the linkage information
#  for that way.

    if ( ( $count_of_ways_needed > 0 ) && ( $category_of_data == $way_data_category ) )
    {
        if ( exists( $need_way_id{ $node_or_way_or_relation_id } ) )
        {
            print OUT_LINKS $node_or_way_or_relation_id . " links_" . $linked_ids . "\n" ;
            $collection_count_way_matches ++ ;
        }
    }


#--------------------------------------------------
#  Generate a standardized version of the name.
#  If there is no name, create a placeholder.

    if ( $name_info ne "" )
    {
        $name = $name_info ;
        &generate_standardized_name( ) ;
        $name_info = $name ;
    } else
    {
        $name_info = "???" ;
    }


#--------------------------------------------------
#  Write business information.

    if ( ( $yes_or_no_get_business_info == $yes_yes ) && ( $business_tag_info ne "" ) )
    {
        if ( $business_web_info eq "" )
        {
            $business_web_info = "no_web" ;
        }
        $business_tag_info =~ s/ +$// ;
        $remaining_info = $name_info . " " . $business_tag_info . " " . $business_web_info ;
        if ( ( $category_of_data == $node_data_category ) && ( $latitude ne "" ) && ( $longitude ne "" ) )
        {
            &convert_into_loc_format( ) ;
            if ( $yes_or_no_opened_biz_node_file != $yes_yes )
            {
                open( BIZ_NODE_FILE , ">" . $optional_prefix_path_for_output . 'output_business_node_info.txt' ) ;
            $yes_or_no_opened_biz_node_file = $yes_yes ;
            }
            print BIZ_NODE_FILE "b " . $location_loc . " " . $node_or_way_or_relation_id . " " . $remaining_info . "\n" ;
            $collection_count_biz_node ++ ;
        } elsif ( $category_of_data == $way_data_category )
        {
            if ( $yes_or_no_opened_biz_way_file != $yes_yes )
            {
                open( BIZ_WAY_FILE , ">" . $optional_prefix_path_for_output . 'output_business_way_info.txt' ) ;
                $yes_or_no_opened_biz_way_file = $yes_yes ;
            }
            print BIZ_WAY_FILE "b " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
            $collection_count_biz_way ++ ;
        } elsif ( $category_of_data == $relation_data_category )
        {
            if ( $yes_or_no_opened_biz_relation_file != $yes_yes )
            {
                open( BIZ_RELATION_FILE , ">" . $optional_prefix_path_for_output . 'output_business_relation_info.txt' ) ;
                $yes_or_no_opened_biz_relation_file = $yes_yes ;
            }
            print BIZ_RELATION_FILE "b " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
            $collection_count_biz_relation ++ ;
        }
    }


#--------------------------------------------------
#  Write city information.
#
#  If the variable "city_tag_info" is empty,
#  ignore the info.
#
#  A missing name is not OK, unless there is a
#  non-empty "label_at_info" value.
#
#  Countries have an admin level of 2, and should
#  have an ISO3166-1 value.
#
#  The admin level may always be empty
#  for relations; it may only apply to
#  node and way info.

    if ( ( $yes_or_no_get_city_info == $yes_yes ) && ( $city_tag_info ne "" ) )
    {
        if ( $label_at_info eq "" )
        {
            $label_at_info = "no_label" ;
        }
        $alternate_name_info =~ s/ +$// ;
        if ( $alternate_name_info eq "" )
        {
            $alternate_name_info = "no_alt_name" ;
        } else
        {
            $name = $alternate_name_info ;
            &generate_standardized_name( ) ;
            $alternate_name_info = $name ;
        }
        if ( $is_in_tag_info eq "" )
        {
            $is_in_tag_info = "no_is_in" ;
        }
        $is_in_tag_info =~ s/ +$// ;
        $city_tag_info =~ s/ +$// ;
        $remaining_info = $name_info . " " . $label_at_info . " " . $alternate_name_info . " lang_count_" . $count_of_foreign_lang_names . " " . $city_tag_info . " " . $is_in_tag_info ;
        if ( ( $category_of_data == $node_data_category ) && ( $latitude ne "" ) && ( $longitude ne "" ) )
        {
            &convert_into_loc_format( ) ;
            if ( $yes_or_no_opened_city_node_file != $yes_yes )
            {
                open( CITY_NODE_FILE , ">" . $optional_prefix_path_for_output . 'output_city_node_info.txt' ) ;
                $yes_or_no_opened_city_node_file = $yes_yes ;
            }
            print CITY_NODE_FILE "c " . $location_loc . " " . $node_or_way_or_relation_id . " " . $remaining_info . "\n" ;
            $collection_count_city_node ++ ;
        } elsif ( $category_of_data == $way_data_category )
        {
            if ( $yes_or_no_opened_city_way_file != $yes_yes )
            {
                open( CITY_WAY_FILE , ">" . $optional_prefix_path_for_output . 'output_city_way_info.txt' ) ;
                $yes_or_no_opened_city_way_file = $yes_yes ;
            }
            print CITY_WAY_FILE "c " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
            $collection_count_city_way ++ ;
        } elsif ( $category_of_data == $relation_data_category )
        {
            if ( $yes_or_no_opened_city_relation_file != $yes_yes )
            {
                open( CITY_RELATION_FILE , ">" . $optional_prefix_path_for_output . 'output_city_relation_info.txt' ) ;
                $yes_or_no_opened_city_relation_file = $yes_yes ;
            }
            print CITY_RELATION_FILE "c " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
            $collection_count_city_relation ++ ;
        }
    }


#--------------------------------------------------
#  Write street information, which can be ways or
#  relations.  Nodes along a street are not
#  handled in this script because a different
#  script must get the latitude and longitude of
#  EVERY node and supply the needed ones to the
#  script that merges that data with the street
#  ways and street relations.  If the route is
#  designated as being for bicycles, hiking,
#  buses, etc., do not write the info.

    if ( ( $yes_or_no_get_street_info == $yes_yes ) && ( $category_of_data == $node_data_category ) )
    {
        if ( ( $street_tag_info ne "" ) && ( $street_tag_info !~ /^_route_((bicycle)|(cycleway)|(bus)|(hiking)|(ski)|(piste)|(trail)|(subway)|(mtb))_$/ ) )
        {
            $alternate_name_info =~ s/ +$// ;
            if ( $alternate_name_info eq "" )
            {
                $alternate_name_info = "no_alt_name" ;
            } else
            {
                $name = $alternate_name_info ;
                &generate_standardized_name( ) ;
                $alternate_name_info = $name ;
            }
            $remaining_info = $name_info . " " . $street_tag_info . " " . $alternate_name_info ;
            if ( $category_of_data == $way_data_category )
            {
                if ( $yes_or_no_opened_street_way_file != $yes_yes )
                {
                    open( STREET_WAY_FILE , ">" . $optional_prefix_path_for_output . 'output_street_way_info.txt' ) ;
                    $yes_or_no_opened_street_way_file = $yes_yes ;
                }
                print STREET_WAY_FILE "s " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
                $collection_count_street_way ++ ;
            } elsif ( $category_of_data == $relation_data_category )
            {
                if ( $yes_or_no_opened_street_relation_file != $yes_yes )
                {
                    open( STREET_RELATION_FILE , ">" . $optional_prefix_path_for_output . 'output_street_relation_info.txt' ) ;
                    $yes_or_no_opened_street_relation_file = $yes_yes ;
                }
                print STREET_RELATION_FILE "s " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
                $collection_count_street_relation ++ ;
            }
        }
    }


#--------------------------------------------------
#  Reset values for the next node, way, or
#  relation.

    $node_id_number_only = "" ; 
    $node_id = "" ;
    $way_id_number_only = "" ;
    $way_id = "" ;
    $relation_id_number_only = "" ;
    $relation_id = "" ;
    $node_or_way_or_relation_id = "" ;
    $latitude = "" ;
    $name_info = "" ;
    $alternate_name_info = "" ;
    $city_tag_info = "" ;
    $street_tag_info = "" ;
    $business_tag_info = "" ;
    $business_web_info = "" ;
    $linked_ids = "" ;
    $label_at_info = "" ;
    $count_of_foreign_lang_names = 0 ;
    $is_in_tag_info = "" ;


#--------------------------------------------------
#  End of subroutine.

}


#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#
#  Subroutine:
#
#  convert_into_loc_format
#
#--------------------------------------------------
#
#  Split the node latitude and longitude values
#  into a nines-complement integer notation
#  (which eliminates minus signs and decimal points).
#
#  Always use the same number of digits.
#
#--------------------------------------------------

sub convert_into_loc_format
{

    ( $latitude_int , $latitude_dec ) = split( /\./ , $latitude ) ;
    if ( $latitude_int =~ /-/ )
    {
        $latitude_int =~ s/-// ;
        $latitude_int =~ tr/0123456789/9876543210/ ;
        $latitude_dec =~ tr/0123456789/9876543210/ ;
        $nine_digits_needed_for_latitude_integer_portion = 3 - length( $latitude_int ) ;
        $nine_digits_needed_for_latitude_decimal_portion = 7 - length( $latitude_dec ) ;
        if ( $nine_digits_needed_for_latitude_decimal_portion < 0 )
        {
            $nine_digits_needed_for_latitude_decimal_portion = 0 ;
        }
        $latitude_string = "0" . $nine_digits_of_count[ $nine_digits_needed_for_latitude_integer_portion ] . $latitude_int . $latitude_dec . $nine_digits_of_count[ $nine_digits_needed_for_latitude_decimal_portion ] ;
    } else
    {
        $zero_digits_needed_for_latitude_integer_portion = 3 - length( $latitude_int ) ;
        $zero_digits_needed_for_latitude_decimal_portion = 7 - length( $latitude_dec ) ;
        if ( $zero_digits_needed_for_latitude_decimal_portion < 0 )
        {
            $zero_digits_needed_for_latitude_decimal_portion = 0 ;
        }
        $latitude_string = "1" . $zero_digits_of_count[ $zero_digits_needed_for_latitude_integer_portion ] . $latitude_int . $latitude_dec . $zero_digits_of_count[ $zero_digits_needed_for_latitude_decimal_portion ] ;
    }
    ( $longitude_int , $longitude_dec ) = split( /\./ , $longitude ) ;
    if ( $longitude_int =~ /-/ )
    {
        $longitude_int =~ s/-// ;
        $longitude_int =~ tr/0123456789/9876543210/ ;
        $longitude_dec =~ tr/0123456789/9876543210/ ;
        $nine_digits_needed_for_longitude_integer_portion = 3 - length( $longitude_int ) ;
        $nine_digits_needed_for_longitude_decimal_portion = 7 - length( $longitude_dec ) ;
        if ( $nine_digits_needed_for_longitude_decimal_portion < 0 )
        {
            $longitude_dec = substr( $longitude_dec , 0 , 7 ) ;
            $nine_digits_needed_for_longitude_decimal_portion = 0 ;
        }
        $longitude_string = "0" . $nine_digits_of_count[ $nine_digits_needed_for_longitude_integer_portion ] . $longitude_int . $longitude_dec . $nine_digits_of_count[ $nine_digits_needed_for_longitude_decimal_portion ] ;
    } else
    {
        $zero_digits_needed_for_longitude_integer_portion = 3 - length( $longitude_int ) ;
        $zero_digits_needed_for_longitude_decimal_portion = 7 - length( $longitude_dec ) ;
        if ( $zero_digits_needed_for_longitude_decimal_portion < 0 )
        {
            $longitude_dec = substr( $longitude_dec , 0 , 7 ) ;
            $zero_digits_needed_for_longitude_decimal_portion = 0 ;
        }
        $longitude_string = "1" . $zero_digits_of_count[ $zero_digits_needed_for_longitude_integer_portion ] . $longitude_int . $longitude_dec . $zero_digits_of_count[ $zero_digits_needed_for_longitude_decimal_portion ] ;
    }
    $location_loc = $latitude_string . " " . $longitude_string ;
    return $location_loc ;


#--------------------------------------------------
#  End of subroutine.

}


#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#  Subroutine to generate a standardized version
#  of the supplied name.

sub generate_standardized_name
{


#--------------------------------------------------
#  Replace any HTML-format characters, such as
#  "&#39;", with the ASCII or single-character
#  equivalent.

# print OUTFILE $name . "\n" ;

    $remainder_string = $name ;
    $name = "" ;
    while ( $remainder_string =~ /^(.*?)\&#([0-9]+);(.*)$/ )
    {
        $name .= $1 ;
        $html_character_number_as_text = $2 ;
        $remainder_string = $3 ;
        $html_character_number = $html_character_number_as_text + 0 ;
        $name .= chr( $html_character_number ) ;
    }
    $name .= $remainder_string ;
    $name =~ s/\&lt;/</gi ;
    $name =~ s/\&gt;/>/gi ;
    $name =~ s/\&amp;/\&/gi ;


#--------------------------------------------------
#  Replace a hyphen with an underscore.
#  No, later handle business names differently
#  from street names and city names.

#    $name =~ s/-/_/g ;


#--------------------------------------------------
#  If the name has any non-ASCII non-letter or
#  non-digit characters, generate a Unicode-based
#  version of the name.
#  ASCII letters and digits and a select few
#  symbols are the only ASCII characters allowed.
#  Underscores are assumed to be placeholders
#  for spaces.

    @octet_number_at_position = unpack( "C*" , $name ) ;
    $yes_or_no_within_ampersand_encoded_character = $no_no ;
    $pointer = -1 ;
    $name = "" ;
    while ( $pointer <= $#octet_number_at_position )
    {
        $pointer ++ ;
        $octet_number = $octet_number_at_position[ $pointer ] ;
        if ( $yes_or_no_within_ampersand_encoded_character == $yes_yes )
        {
            $name .= chr( $octet_number ) ;
            if ( $octet_number == ord( ";" ) )
            {
                $yes_or_no_within_ampersand_encoded_character = $no_no ;
            }
        } elsif ( ( $octet_number == ord( '&' ) ) && ( $octet_number_at_position[ $pointer + 1 ] == ord( '#' ) ) )
        {
            $name .= chr( $octet_number ) ;
            $yes_or_no_within_ampersand_encoded_character = $yes_yes ;
        } elsif ( $octet_number == ord( " " ) )
        {
            $name .= "_" ;
        } elsif ( ( $octet_number == ord( "_" ) ) || ( $octet_number == 45 ) )
        {
            $name .= chr( $octet_number ) ;
        } elsif ( ( ( $octet_number > 47 ) && ( $octet_number < 58 ) ) || ( ( $octet_number > 64 ) && ( $octet_number < 91 ) ) || ( ( $octet_number > 96 ) && ( $octet_number < 123 ) ) )
        {
            $name .= chr( $octet_number ) ;
        } elsif ( $octet_number == 13 )
        {
            last ;
        } elsif ( $octet_number >= 0xfc )
        {
            $unicode_number = ( ( ( ( ( ( ( ( ( ( $octet_number - 0xfc ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 2 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 3 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 4 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 5 ] - 128 ;
            $name .= '&#' . $unicode_number . ';' ;
            $pointer += 5 ;
        } elsif ( $octet_number >= 0xf8 )
        {
            $unicode_number = ( ( ( ( ( ( ( ( $octet_number - 0xf8 ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 2 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 3 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 4 ] - 128 ;
            $name .= '&#' . $unicode_number . ';' ;
            $pointer += 4 ;
        } elsif ( $octet_number >= 0xf0 )
        {
            $unicode_number = ( ( ( ( ( ( $octet_number - 0xf0 ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 2 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 3 ] - 128 ;
            $name .= '&#' . $unicode_number . ';' ;
            $pointer += 3 ;
        } elsif ( $octet_number >= 0xe0 )
        {
            $unicode_number = ( ( ( ( $octet_number - 0xe0 ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 2 ] - 128 ;
            $name .= '&#' . $unicode_number . ';' ;
            $pointer += 2 ;
        } elsif ( $octet_number >= 0xc0 )
        {
            $unicode_number = ( ( $octet_number - 0xc0 ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ;
            $name .= '&#' . $unicode_number . ';' ;
            $pointer += 1 ;
        } elsif ( $octet_number > 0 )
        {
            $unicode_number = $octet_number ;
            $name .= '&#' . $unicode_number . ';' ;
        } elsif ( $octet_number == 0 )
        {
            last ;
        }
    }


#--------------------------------------------------
#  End of subroutine.

    return ;

}
