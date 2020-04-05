#--------------------------------------------------
#       osm_split_and_abbrev_node_way_relation.pl
#--------------------------------------------------

#  (c) Copyright 2014-2016 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Processes XML data file planet-latest.osm.bz from:
#  https://ftp.osuosl.org/pub/openstreetmap/planet
#
#  Usage:
#  bzcat planet-latest.osm.bz | perl osm_split_and_abbrev_node_way_relation.pl
#
#  Note: output to terminal shows node count as progress indicator
#  In second terminal, run "top" Linux command to monitor CUP & memory usage


#--------------------------------------------------
#  Specify which data is being extracted.
#
#  Code further below can be used or commented-out to
#  skip, or not skip, node or way or relation data.

$yes_or_no_get_street_info = "no" ;
$yes_or_no_get_business_info = "yes" ;
$yes_or_no_get_city_info = "yes" ;
$yes_or_no_get_linkage_way_info = "yes" ;

$yes_or_no_testing_only = "no" ;
$testing_collection_threshold = 10 ;


#--------------------------------------------------
#  Specify Linux or Windows path style.

# $slash_or_backslash = "\\" ;  # windows
$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Specify how many nodes should be stored in
#  memory before writing them to separate files.
#  This number must not be small, or else each
#  file is opened and closed to write just a few
#  lines of data.
#
#  For testing, can use smaller number.

# $trigger_count_node_info_lines_stored_ready_to_write = 1000 ;
$trigger_count_node_info_lines_stored_ready_to_write = 1000000 ;


#--------------------------------------------------
#  For progress logging purposes, specify the input
#  file size.
#  When input_file_byte_size was 648278370000 , file size was 75.2 GB.
#  Now file size is 81 GB so input_file_byte_size changed to ‭698300000000.

$input_file_byte_size = 698300000000 ;


#--------------------------------------------------
#  Specify file paths.

# $input_file_including_path = '/media/Elements/OpenStreetMapData/OsmUncompressed/osm_planet_uncompressed.xml' ;

# $optional_prefix_path_for_output = '/media/Elements/OpenStreetMapData/output_files_2015octLater/' ;

# $input_file_including_path = "G:\\OpenStreetMapData\\OsmUncompressed\\osm_planet_uncompressed.xml" ;

$optional_prefix_path_for_output = "" ;

#$optional_prefix_path_for_output = "F:\\CitiesBusinessesIntersectionsPostalcodes\\calc_results\\" ;

$optional_prefix_path_for_output_links_big_file = "" ;

# $optional_prefix_path_for_output_links_big_file = "F:\\CitiesBusinessesIntersectionsPostalcodes\\calc_results\\" ;

$path_and_filename_prefix_for_nodes =  $optional_prefix_path_for_output . 'nodes' . $slash_or_backslash . 'output_nodes_in_category_' ;


#--------------------------------------------------
#  Open the input file.

# NOW USING STDIN!

# open( INFILE , "<" . $input_file_including_path ) ;


#--------------------------------------------------
#  Create the output files.

open( OUT_LOG , ">" . $optional_prefix_path_for_output . 'output_log_split_node_way_relation.txt' ) ;

if ( $yes_or_no_get_business_info eq "yes" )
{
    open( BIZ_NODE_FILE , ">" . $optional_prefix_path_for_output . 'output_business_node_info.txt' ) ;
    open( BIZ_WAY_FILE , ">" . $optional_prefix_path_for_output . 'output_business_way_info.txt' ) ;
    open( BIZ_RELATION_FILE , ">" . $optional_prefix_path_for_output . 'output_business_relation_info.txt' ) ;
}

if ( $yes_or_no_get_city_info eq "yes" )
{
    open( CITY_NODE_FILE , ">" . $optional_prefix_path_for_output . 'output_city_node_info.txt' ) ;
    open( CITY_WAY_FILE , ">" . $optional_prefix_path_for_output . 'output_city_way_info.txt' ) ;
    open( CITY_RELATION_FILE , ">" . $optional_prefix_path_for_output . 'output_city_relation_info.txt' ) ;
}

if ( $yes_or_no_get_street_info eq "yes" )
{
    open( STREET_WAY_FILE , ">" . $optional_prefix_path_for_output . 'output_street_way_info.txt' ) ;
}

if ( $yes_or_no_get_linkage_way_info eq "yes" )
{
    open( OTHER_WAY_FILE , ">" . $optional_prefix_path_for_output_links_big_file . 'output_linkage_way_info.txt' ) ;
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
#  but it is sometimes used for that purpose;
#  those locations will be ignored until the tag is fixed
$info_type_from_tag_and_value{ "place_locality" } = "ignore" ;

$info_type_from_tag_and_value{ "place_island" } = "ignore" ;


#--------------------------------------------------
#  Indicate street tags of interest.

$info_type_from_tag{ "highway" } = "street" ;
$info_type_from_tag{ "motorway" } = "street" ;
$info_type_from_tag{ "route" } = "street" ;
$info_type_from_tag{ "tiger:name_type" } = "street" ;

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
#  "piste" is a bobsled route?


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
$skipped_over = "" ;

$category_of_data = "" ;
$previous_category_of_data = "" ;
$encountered_transition_from_nodes_to_ways = "no" ;
$encountered_transition_from_ways_to_relations = "no" ;

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
#  Optional code that skips over the node info.

# seek( INFILE , 497655700000 , 0 ) ;
# $input_line = <INFILE> ;


#--------------------------------------------------
#  Optional code that skips over the way info.

# seek( STDIN , 660724003000 , 0 ) ;
# $input_line = <INFILE> ;


#--------------------------------------------------
#  Optional code to help find the transition between
#  node and way info.

# while( $input_line = <INFILE> )
# {
#    chomp( $input_line ) ;
#    print $input_line . "\n" ;
#    $line_counter ++ ;
#    if ( $line_counter > 500 )
#    if ( $input_line =~ /<way/ )
#    {
#        $now_at = tell( INFILE ) ;
#        print "now at " . $now_at . "\n" ;
#        exit ;
#    }
# }


#--------------------------------------------------
#  Read each line in the file.

$line_number = 0 ;
while( $input_line = <STDIN> )
# while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    $input_line =~ s/[ \n\r\t]+/ /sg ;
    $line_number ++ ;


#--------------------------------------------------
#  Uncomment if need to view segment of input file for
#  debugging purposes.
#
#  Was used to discover that the following data
#  mistakenly specified that the official_name for
#  Canada is "Isle of Man":
#
#     <tag k="int_name" v="Canada" />
#     <tag k="official_name" v="Isle of Man" />
#     <tag k="ISO3166-1" v="ca" />
#     <tag k="name" v="Canada" />

#    if ( ( $input_line =~ /<relation / ) && ( $input_line =~ /1428125/ ) )
#    {
#        print "line number " . $line_number . "\n" ;
#        print $input_line . "\n" ;
#        while( $input_line = <INFILE> )
#        {
#            chomp( $input_line ) ;
#            $input_line =~ s/[\n\r\t]/ /sg ;
#            $input_line =~ s/  +/ /g ;
#            print $input_line . "\n" ;
#            if ( $input_line =~ /<\/relation>/ )
#            {
#                exit ;
#            }
#        }
#    } else
#    {
#        next ;
#    }


#--------------------------------------------------
#  If needed for debugging, display some specific
#  lines of the input file.

    # if ( $input_line =~ /<node/ )
    # {
        # print $input_line . "\n" ;
        # $show_line_count ++ ;
        # if ( $show_line_count > 1000 )
        # {
            # exit ;
        # }
    # }


#--------------------------------------------------
#  Handle the beginning of a node, way, or relation.

    if ( $input_line =~ /^ *<node id="([0-9]+)".* lat="([\-0-9\.]+)".* lon="([\-0-9\.]+)"/ )
    {
        $node_id = $1 ;
        $latitude = $2 ;
        $longitude = $3 ;
        $category_of_data = "node" ;
        $node_or_way_or_relation_id = "n" . $node_id ;
        $node_count ++ ;
    } elsif ( $input_line =~ /^ *<way id="([0-9]+)"/ )
    {
        $way_id = $1 ;
        $category_of_data = "way" ;
        $node_or_way_or_relation_id = "w" . $way_id ;
        $way_count ++ ;
    } elsif ( $input_line =~ /^ *<relation id="([0-9]+)"/ )
    {
        $relation_id = $1 ;
        $category_of_data = "relation" ;
        $node_or_way_or_relation_id = "r" . $relation_id ;
        $relation_count ++ ;
    } elsif ( $input_line =~ /^ *<relation / )
    {
        $category_of_data = "relation" ;
        $relation_id = "???" ;
        $node_or_way_or_relation_id = "r" . $relation_id ;
        $relation_count ++ ;
    }


#--------------------------------------------------
#  At the end of all the node info (when the first
#  way data is encountered), write any street
#  node info that is waiting to be written.

    if ( ( $category_of_data eq "way" ) && ( $count_node_info_lines_stored_ready_to_write > 0 ) )
    {
        foreach $category_for_node_number ( keys( %output_lines_for_node_category ) )
        {
            $output_lines = $output_lines_for_node_category{ $category_for_node_number } ;
            open OUT_NODES , ">>" . $path_and_filename_prefix_for_nodes . $category_for_node_number . '.txt' ;
            print OUT_NODES $output_lines ;
            close OUT_NODES ;
        }
        %output_lines_for_node_category = ( ) ;
        $count_node_info_lines_stored_ready_to_write = 0 ;
    }


#--------------------------------------------------
#  Optional code that ignores all node info.

#    if ( $category_of_data eq "node" )
#    {
#        next ;
#    }


#--------------------------------------------------
#  Optional code that exits when way data reached.

#    if ( $category_of_data eq "way" )
#    {
#        exit ;
#    }


#--------------------------------------------------
#  Optional code that exits when relation data reached.

#    if ( $category_of_data eq "relation" )
#    {
#        exit ;
#    }


#--------------------------------------------------
#  Get info about a link between a way and node,
#  or between a relation and way, or between
#  a relation and node.
#  If the relationship is that the subordinate
#  item is a label for the item, then save the
#  item ID differently -- in case this item is
#  a city, in which case the label is the name(s)
#  of the city (possibly in different languages).

    if ( ( $category_of_data eq "way" ) && ( $input_line =~ /^ *<nd ref="([0-9]+)"/ ) )
    {
        $node_id = $1 ;
        if ( $input_line =~ / role="label"/ )
        {
            $label_at_info = "label_at_n" . $node_id ;
        } else
        {
            $linked_ids .= "n" . $node_id . "_" ;
        }
    } elsif ( ( $category_of_data eq "relation" ) && ( $input_line =~ /^ *<member type="way" ref="([0-9]+)"/ ) )
    {
        $way_id = $1 ;
        $linked_ids .= "w" . $way_id . "_" ;
    } elsif ( ( $category_of_data eq "relation" ) && ( $input_line =~ /^ *<member type="node" ref="([0-9]+)"/ ) )
    {
        $node_id = $1 ;
        if ( $input_line =~ / role="label"/ )
        {
            $label_at_info = "label_at_n" . $node_id ;
        } else
        {
            $linked_ids .= "n" . $node_id . "_" ;
        }


#--------------------------------------------------
#  At the end of a node, way, or relation, prepare
#  to write the collected node, way, or relation
#  information.
#  Note that some node info is on just a single line.

    } elsif ( ( $input_line =~ /^ *<\/node.*> *$/ ) || ( $input_line =~ /^ *<node.*\/> *$/ ) || ( $input_line =~ /^ *<\/way *>/ ) || ( $input_line =~ /^ *<\/relation *>/ ) )
    {
        $overlapping_roles_count = 0 ;
        if ( $city_tag_info ne "" )
        {
            $overlapping_roles_count ++ ;
        }
        if ( $street_tag_info ne "" )
        {
            $overlapping_roles_count ++ ;
        }
        if ( $business_tag_info ne "" )
        {
            $overlapping_roles_count ++ ;
        }
        if ( $overlapping_roles_count > 1 )
        {
#            print $node_or_way_or_relation_id . " has overlapping roles: " . $city_tag_info . "   " . $street_tag_info . "   " . $business_tag_info . "\n" ;
        }


#--------------------------------------------------
#  If testing, ignore additional items beyond the
#  requested number of items of each data type.
#
#  Remember that "linked_ids" variable is used by
#  more than just the "other" links data.

        if ( $yes_or_no_testing_only eq "yes" )
        {
            if ( $business_tag_info ne "" )
            {
                if ( ( ( $category_of_data eq "node" ) && ( $collection_count_biz_node > $testing_collection_threshold ) ) || ( ( $category_of_data eq "way" ) && ( $collection_count_biz_way > $testing_collection_threshold ) ) || ( ( $category_of_data eq "relation" ) && ( $collection_count_biz_relation > $testing_collection_threshold ) ) )
                {
                    $business_tag_info = "" ;
                }
            } elsif ( $city_tag_info ne "" )
            {
                if ( ( ( $category_of_data eq "node" ) && ( $collection_count_city_node > $testing_collection_threshold ) ) || ( ( $category_of_data eq "way" ) && ( $collection_count_city_way > $testing_collection_threshold ) ) || ( ( $category_of_data eq "relation" ) && ( $collection_count_city_relation > $testing_collection_threshold ) ) )
                {
                    $city_tag_info = "" ;
                }
            } elsif ( $street_tag_info ne "" )
            {
                if ( ( $category_of_data eq "way" ) && ( $collection_count_street_way > $testing_collection_threshold ) )
                {
                    $street_tag_info = "" ;
                }
            } elsif ( ( $linked_ids ne "" ) && ( $category_of_data eq "way" ) && ( $collection_count_linkage > $testing_collection_threshold ) )
            {
                $linked_ids = "" ;
            }
        }


#--------------------------------------------------
#  Write business information.
#  Omit items that have names in ALL CAPS.

        if ( $business_tag_info ne "" )
        {
            if ( ( $yes_or_no_get_business_info eq "yes" ) && ( $name_info ne "" ) && ( $name_info !~ /^[A-Z_]+$/ ) )
            {
                $name = $name_info ;
                &generate_standardized_name( ) ;
                $name_info = $name ;
                if ( $business_web_info eq "" )
                {
                    $business_web_info = "no_web" ;
                }
                $business_tag_info =~ s/ +$// ;
                $remaining_info = $name_info . " " . $business_tag_info . " " . $business_web_info ;
                if ( ( $category_of_data eq "node" ) && ( $latitude ne "" ) )
                {
                    &convert_into_loc_format( ) ;
                    print BIZ_NODE_FILE "b " . $location_loc . " " . $node_or_way_or_relation_id . " " . $remaining_info . "\n" ;
                    $collection_count_biz_node ++ ;
                } elsif ( $category_of_data eq "way" )
                {
                    print BIZ_WAY_FILE "b " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info. "\n" ;
                    $collection_count_biz_way ++ ;
                } elsif ( $category_of_data eq "relation" )
                {
                    print BIZ_RELATION_FILE "b " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info. "\n" ;
                    $collection_count_biz_relation ++ ;
                }
            }
            if ( $overlapping_roles_count <= 1 )
            {
                $latitude = "" ;
            }


#--------------------------------------------------
#  Write city information.
#
#  A missing name is not OK, unless there is a
#  non-empty "label_at_info" value.
#
#  Omit items that have names in ALL CAPS.
#
#  Countries have an admin level of 2, and should
#  have an ISO3166-1 value.
#
#  If the variable "city_tag_info" is empty,
#  ignore the info.
#
#  The admin level may always be empty
#  for relations; it may only apply to
#  node and way info.

        } elsif ( ( $yes_or_no_get_city_info eq "yes" ) && ( $city_tag_info ne "" ) && ( ( ( $name_info ne "" ) && ( $name_info !~ /^[A-Z_]+$/ ) ) || ( $label_at_info ne "" ) ) )
        {
            $name = $name_info ;
            &generate_standardized_name( ) ;
            $name_info = $name ;
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
            if ( ( $category_of_data eq "node" ) && ( $latitude ne "" ) )
            {
                &convert_into_loc_format( ) ;
                print CITY_NODE_FILE "c " . $location_loc . " " . $node_or_way_or_relation_id . " " . $remaining_info . "\n" ;
                if ( $overlapping_roles_count <= 1 )
                {
                    $latitude = "" ;
                }
                $collection_count_city_node ++ ;
            } elsif ( $category_of_data eq "way" )
            {
                print CITY_WAY_FILE "c " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
                $collection_count_city_way ++ ;
            } elsif ( $category_of_data eq "relation" )
            {
                print CITY_RELATION_FILE "c " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
                $collection_count_city_relation ++ ;
            }


#--------------------------------------------------
#  Write (way or relation) street information.
#
#  If the entire tag indicates just one ignored
#  type of info, then the way or relation is
#  ignored.  If instead, there is a mixure of
#  info types, then the way or relation is not
#  ignored.
#
#  Ignore street relation info because it is
#  not relevant for intersections.

        } elsif ( ( $category_of_data eq "way" ) && ( $yes_or_no_get_street_info eq "yes" ) && ( $street_tag_info ne "" ) && ( $name_info ne "" ) )
        {
            if ( $street_tag_info !~ /^_route_((bicycle)|(cycleway)|(bus)|(hiking)|(ski)|(piste)|(trail)|(subway)|(mtb))_$/ )
            {
                $name = $name_info ;
                &generate_standardized_name( ) ;
                $name_info = $name ;
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
                print STREET_WAY_FILE "s " . $node_or_way_or_relation_id . " links_" . $linked_ids . " " . $remaining_info . "\n" ;
                $collection_count_street_way ++ ;
            }


#--------------------------------------------------
#  If there is way info that is not of a recognized
#  type (street or business or city), yet it also is
#  not of an ignored type, write it.
#  This information may be part of a relation that
#  refers to these way items as the linkage to the
#  nodes that specify locations -- of a building's
#  corners or a city boundary.

        } elsif ( ( $yes_or_no_get_linkage_way_info = "yes" ) && ( $category_of_data eq "way" ) && ( $linked_ids =~ /[^ ]/ ) )
        {
            print OTHER_WAY_FILE "l " . $node_or_way_or_relation_id . " links_" . $linked_ids . "\n" ;
            $collection_count_linkage ++ ;
        }


#--------------------------------------------------
#  If needed, write node location information.
#  The type of node is unknown except that it is
#  not one of the ignored data types.
#
#  This information is split into different files,
#  with the last three digits of the node ID number
#  determining which file.

        if ( $yes_or_no_get_street_info eq "yes" )
        {
            if ( ( $latitude ne "" ) && ( $node_id ne "" ) )
            {
                $category_for_node_number = substr( $node_id , -3 , 3 ) ;
                &convert_into_loc_format( ) ;
                $output_lines_for_node_category{ $category_for_node_number } .= "n" . $node_id . " " . $location_loc . "\n" ;
                $count_node_info_lines_stored_ready_to_write ++ ;
                $collection_count_node_uncategorized ++ ;
                if ( $count_node_info_lines_stored_ready_to_write > $trigger_count_node_info_lines_stored_ready_to_write )
                {
                    foreach $category_for_node_number ( keys( %output_lines_for_node_category ) )
                    {
                        $output_lines = $output_lines_for_node_category{ $category_for_node_number } ;
                        open OUT_NODES , ">>" . $path_and_filename_prefix_for_nodes . $category_for_node_number . '.txt' ;
                        print OUT_NODES $output_lines ;
                        close OUT_NODES ;
                    }
                    %output_lines_for_node_category = ( ) ;
                    $count_node_info_lines_stored_ready_to_write = 0 ;
                }
            }
        }


#--------------------------------------------------
#  Show progress.

        if ( $progress_counter > 500000 )
        {
            $now_at = $input_file_byte_size ;
#            $now_at = tell( INFILE ) ;
            $percent_complete_tenths = sprintf( "%d" , int( 1000 * ( $now_at / $input_file_byte_size ) ) ) ;
            if ( $encountered_transition_from_ways_to_relations eq "yes" )
            {
                $log_info = " r " . " b " . $collection_count_biz_relation . " c " . $collection_count_city_relation ;
#                $log_info = $percent_complete_tenths . " r " . " b " . $collection_count_biz_relation . " c " . $collection_count_city_relation ;
            } elsif ( $encountered_transition_from_nodes_to_ways eq "yes" )
            {
                $log_info = " w " . " b " . $collection_count_biz_way . " c " . $collection_count_city_way . " s " . $collection_count_street_way . " L " . $collection_count_linkage ;
#                $log_info = $percent_complete_tenths . " w " . " b " . $collection_count_biz_way . " c " . $collection_count_city_way . " s " . $collection_count_street_way . " L " . $collection_count_linkage ;
            } else
            {
                $log_info = " n " . " b " . $collection_count_biz_node . " c " . $collection_count_city_node . " s " . $collection_count_node_uncategorized ;
#                $log_info = $percent_complete_tenths . " n " . " b " . $collection_count_biz_node . " c " . $collection_count_city_node . " s " . $collection_count_node_uncategorized ;
            }
            print $log_info . "\n" ;
            print OUT_LOG $log_info . "\n" ;
            $progress_counter = 0 ;
        }
        $progress_counter ++ ;


#--------------------------------------------------
#  Identify transitions, from nodes to ways, and
#  from ways to relations.
#  Actually, this code identifies the time just after
#  a transition has occurred, such that one item
#  in the new category may have been written.
#  At these transitions close files that no longer
#  need to be kept open.

        if ( $category_of_data ne $previous_category_of_data )
        {
            if ( ( $category_of_data eq "way" ) && ( $previous_category_of_data eq "node" ) )
            {
                $encountered_transition_from_nodes_to_ways = "yes" ;
                close( BIZ_NODE_FILE ) ;
                close( CITY_NODE_FILE ) ;
            }
            if ( ( $category_of_data eq "relation" ) && ( $previous_category_of_data eq "way" ) )
            {
                $encountered_transition_from_ways_to_relations = "yes" ;
                close( BIZ_WAY_FILE ) ;
                close( CITY_WAY_FILE ) ;
                close( STREET_WAY_FILE ) ;
            }
        }
        $previous_category_of_data = $category_of_data ;


#--------------------------------------------------
#  If testing, skip ahead when reaching the requested
#  number of items of each data type.

        if ( $yes_or_no_testing_only eq "yes" )
        {
            if ( $skipped_over eq "" )
            {
#                seek( INFILE , 300000000000 , 0 ) ;
                $skipped_over = "first_nodes" ;
            } elsif ( ( $skipped_over eq "first_nodes" ) && ( $category_of_data eq "node" ) && ( ( $yes_or_no_get_business_info ne "yes" ) || ( $collection_count_biz_node >= $testing_collection_threshold ) ) && ( ( $yes_or_no_get_city_info ne "yes" ) || ( $collection_count_city_node >= $testing_collection_threshold ) ) )
            {
#                seek( INFILE , 497655700000 , 0 ) ;
                $skipped_over = "ways" ;
            } elsif ( ( $skipped_over eq "nodes" ) && ( $category_of_data eq "way" ) && ( ( $yes_or_no_get_business_info ne "yes" ) || ( $collection_count_biz_way >= $testing_collection_threshold ) ) && ( ( $yes_or_no_get_city_info ne "yes" ) || ( $collection_count_city_way >= $testing_collection_threshold ) ) && ( ( $yes_or_no_get_street_info ne "yes" ) || ( $collection_count_street_way >= $testing_collection_threshold ) ) )
            {
#                seek( INFILE , 660724003000 , 0 ) ;
                $skipped_over = "ways" ;
            } elsif ( ( $skipped_over eq "ways" ) && ( $category_of_data eq "relation" ) && ( ( $yes_or_no_get_business_info ne "yes" ) || ( $collection_count_biz_relation >= $testing_collection_threshold ) ) && ( ( $yes_or_no_get_city_info ne "yes" ) || ( $collection_count_city_relation >= $testing_collection_threshold ) ) )
            {
                exit ;
            }
        }


#--------------------------------------------------
#  Reset values for the next node, way, or relation.

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

        $category_of_data = "" ;
        $node_id = "" ;
        $way_id = "" ;
        $relation_id = "" ;
        $node_or_way_or_relation_id = "" ;


#--------------------------------------------------
#  Get tag and value information.
#  Handle data of interest for either node, way,
#  or relation type.
#
#  Do not write nodes and ways and relations
#  that are definitely not of interest.
#  Maritime boundaries are not of interest.
#  A "southbound" node is a bus stop, not a street entity,
#  so it is not of interest.

    } elsif ( $input_line =~ /<tag k="([^"]+)" v="([^"]+)"/ )
    {
        $tag = $1 ;
        $value = $2 ;
        $tag_and_value = $tag . "_" . $value ;
        if ( ( $tag_and_value eq "maritime_yes" ) || ( ( $category_of_data eq "node" ) && ( $value =~ /((north)|(south)|(east)|(west))bound/ ) ) )
        {
            $node_id = "" ;
            $way_id = "" ;
            $latitude = "" ;
            $category_of_data = "" ;
        } elsif ( ( ( $tag eq "route" ) || ( $tag eq "highway" ) ) && ( exists( $route_type_of_no_interest{ $value } ) ) )
        {
            $node_id = "" ;
            $way_id = "" ;
            $relation_id = "" ;
            $category_of_data = "" ;
        } elsif ( $tag eq "admin_level" )
        {
            if ( $yes_or_no_get_city_info eq "yes" )
            {
                $city_tag_info .= $tag_and_value . " " ;
            } else
            {
                $latitude = "" ;
            }
        } elsif ( exists( $info_type_from_tag_and_value{ $tag_and_value } ) )
        {
            if ( $info_type_from_tag_and_value{ $tag_and_value } eq "business" )
            {
                if ( $yes_or_no_get_business_info eq "yes" )
                {
                    $business_tag_info .= $tag_and_value . " " ;
                } else
                {
                    $latitude = "" ;
                }
            } elsif ( $info_type_from_tag_and_value{ $tag_and_value } eq "city" )
            {
                if ( $yes_or_no_get_city_info eq "yes" )
                {
                    $city_tag_info .= $tag_and_value . " " ;
                } else
                {
                    $latitude = "" ;
                }
            } elsif ( $info_type_from_tag_and_value{ $tag_and_value } eq "street" )
            {
                if ( $yes_or_no_get_street_info eq "yes" )
                {
                    $street_tag_info .= $tag_and_value . " " ;
                } else
                {
                    $latitude = "" ;
                }
            } elsif ( $info_type_from_tag_and_value{ $tag_and_value } eq "ignore" )
            {
                $node_id = "" ;
                $way_id = "" ;
                $relation_id = "" ;
                $latitude = "" ;
                $category_of_data = "" ;
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
                if ( $yes_or_no_get_business_info eq "yes" )
                {
                    $business_tag_info .= $tag . "_" . $value_without_spaces . " " ;
                } else
                {
                    $latitude = "" ;
                }
            } elsif ( $info_type_from_tag{ $tag } eq "city" )
            {
                if ( ( $yes_or_no_get_city_info eq "yes" ) && ( $value_without_spaces ne "" ) )
                {
                    if ( ( $tag eq "population" ) && ( $value !~ /^[0-9]+$/ ) )
                    {
                        $ignored_count_of_invalid_population_values ++ ;
                    } else
                    {
                        $city_tag_info .= $tag . "_" . $value_without_spaces . " " ;
                    }
                } else
                {
                    $latitude = "" ;
                }
            } elsif ( $info_type_from_tag{ $tag } eq "street" )
            {
                if ( $yes_or_no_get_street_info eq "yes" )
                {
                    $street_tag_info .= $tag . "_" . $value_without_spaces . " " ;
                } else
                {
                    $latitude = "" ;
                }
            } elsif ( $info_type_from_tag{ $tag } eq "ignore" )
            {
                $node_id = "" ;
                $way_id = "" ;
                $relation_id = "" ;
                $latitude = "" ;
                $category_of_data = "" ;
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
        } elsif ( ( $tag eq "website" ) && ( $yes_or_no_get_business_info eq "yes" ) )
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
        } elsif ( ( $tag =~ /^is_in:/ ) && ( $yes_or_no_get_city_info eq "yes" ) && ( $tag !~ /^is_in:((continent)|(city))/ ) && ( $value ne "Canada" ) && ( $value ne "USA" ) && ( $value ne "United States of America" ) )
        {
            $value =~ s/:/ /g ;
            $value =~ s/\(/ /g ;
            $value =~ s/\)/ /g ;
            $value =~ s/  +/ /g ;
            $value =~ s/^ // ;
            $value =~ s/ $// ;
            $value =~ s/ /_/g ;
            $is_in_tag_info .= $tag . "_" . $value . " " ;
        } elsif ( ( $yes_or_no_get_city_info eq "yes" ) && ( $tag =~ /^ISO3166/ ) & ( $value =~ /^[a-z][a-z]$/i ) )
        {
            $value = lc( $value ) ;
            $city_tag_info .= "country_code_" . $value . " " ;
        } elsif ( $tag eq "amenity" )
        {
            $node_id = "" ;
            $way_id = "" ;
            $relation_id = "" ;
            $latitude = "" ;
            $category_of_data = "" ;
        }
    }


#--------------------------------------------------
#  Repeat the loop to handle the next line.

}


#--------------------------------------------------
#  Just in case there is any node info that is
#  waiting to be written, write it to the output files.

if ( $count_node_info_lines_stored_ready_to_write > 0 )
{
    foreach $category_for_node_number ( keys( %output_lines_for_node_category ) )
    {
        $output_lines = $output_lines_for_node_category{ $category_for_node_number } ;
        open OUT_NODES , ">>" . $path_and_filename_prefix_for_nodes . $category_for_node_number . '.txt' ;
        print OUT_NODES $output_lines ;
        close OUT_NODES ;
    }
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
    $yes_or_no_within_ampersand_encoded_character = "no" ;
    $pointer = -1 ;
    $name = "" ;
    while ( $pointer <= $#octet_number_at_position )
    {
        $pointer ++ ;
        $octet_number = $octet_number_at_position[ $pointer ] ;
        if ( $yes_or_no_within_ampersand_encoded_character eq "yes" )
        {
            $name .= chr( $octet_number ) ;
            if ( $octet_number == ord( ";" ) )
            {
                $yes_or_no_within_ampersand_encoded_character = "no" ;
            }
        } elsif ( ( $octet_number == ord( '&' ) ) && ( $octet_number_at_position[ $pointer + 1 ] == ord( '#' ) ) )
        {
            $name .= chr( $octet_number ) ;
            $yes_or_no_within_ampersand_encoded_character = "yes" ;
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
