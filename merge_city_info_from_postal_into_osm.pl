#--------------------------------------------------
#    merge_city_info_from_postal_into_osm.pl
#--------------------------------------------------

#  (c) Copyright 2014-2023 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Specify the file that contains the state abbreviations.

$input_file_name_state_abbreviations = 'output_state_country_abbreviations_for_each_city.txt' ;


#--------------------------------------------------
#  Specify the log file.

$log_file_name = 'output_log_merge_city_info_from_postal_into_osm.txt' ;


#--------------------------------------------------
#  Get the state abbreviations and country codes
#  from the postal-code info file.
#
#  Allow for name inconsistency between
#  postal-code info and Open Street Map data:
#  OSM:  Saint Louis MO  node=151786910
#  Zipcode data:  St. Louis MO

open( IN_STATE , "<" . $input_file_name_state_abbreviations ) ;
while ( $input_line = <IN_STATE> ) {
    chomp ( $input_line ) ;
    if ( $input_line =~ /^([^ ]+) +([^ ]+) +([^ ]+) +([0-9]+) +([0-9]+) *$/ )
    {
        $city_name_searchable = $1 ;
        $state_abbreviation = $2 ;
        $country_code = $3 ;
        $latitude = $4 ;
        $longitude = $5 ;
        $state_abbreviation = lc( $state_abbreviation ) ;
        $combo_city_latitude_longitude = $city_name_searchable . "_" . substr( $latitude , 0 , 4 ) . "_" . substr( $longitude , 0 , 4 ) ;
        $state_abbreviation_for_combo{ $combo_city_latitude_longitude } = $state_abbreviation ;
        $country_code_for_combo{ $combo_city_latitude_longitude } = $country_code ;
        if ( $combo_city_latitude_longitude =~ /saint_/ )
        {
            $combo_city_latitude_longitude =~ s/saint_/st._/ ;
            $state_abbreviation_for_combo{ $combo_city_latitude_longitude } = $state_abbreviation ;
            $country_code_for_combo{ $combo_city_latitude_longitude } = $country_code ;
        }
    }
}


#--------------------------------------------------
#  Begin a loop that handles each line of city info.
#
#  Sample input line:
#    london ?? gb 10515073219 09998723525 n107775 London
#    portland ?? ?? 10455202471 98773258050 n1666626393 Portland

while ( $input_line = <STDIN> ) {
    chomp ( $input_line ) ;
    if ( $input_line =~ /^([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) *$/ )
    {
        $city_name_searchable = $1 ;
        $state_or_province = $2 ;
        $country_code = $3 ;
        $latitude = $4 ;
        $longitude = $5 ;
        $node_id = $6 ;
        $displayed_city_name = $7 ;


#--------------------------------------------------
#  If the OSM-source city matches a postal-code-source
#  city that has the same location, then 
#  supply the state/province and country code.
#  For debugging, keep track of which cities
#  were matched.

        $combo_city_latitude_longitude = $city_name_searchable . "_" . substr( $latitude , 0 , 4 ) . "_" . substr( $longitude , 0 , 4 ) ;
        if ( exists( $state_abbreviation_for_combo{ $combo_city_latitude_longitude } ) )
        {
            $state_abbreviation = $state_abbreviation_for_combo{ $combo_city_latitude_longitude } ;
#            print $city_name_searchable . "_" . $state_abbreviation . " " . uc( $state_abbreviation ) . " " . "US" . " " . $latitude . " " . $longitude . " " . $node_id . " " . $displayed_city_name . "\n" ;

            $country_code = $country_code_for_combo{ $combo_city_latitude_longitude } ;
            $state_or_province = $state_abbreviation ;

            $found_combo{ $combo_city_latitude_longitude } = "y" ;

#            $city_name = $combo_city_latitude_longitude ;
#            $city_name =~ s/[0-9]+_[0-9]+$// ;
#            $found_city{ $city_name_searchable . "_" . $state_abbreviation } = "y" ;
        } else
        {
            $not_found_combo{ $combo_city_latitude_longitude } = "y" ;
        }


#--------------------------------------------------
#  If the node for Washington DC has an unknown
#  state code, ignore it because another entry has
#  the correct information.

        if ( ( $node_id eq "n158368533" ) && ( $state_or_province eq "??" ) )
        {
            next ;
        }


#--------------------------------------------------
#  If the country code is not a two-letter code,
#  specify it as unknown.

        if ( $country_code !~ /^[A-Z][A-Z]$/i )
        {
            $country_code = "??" ;
        }


#--------------------------------------------------
#  Reminder: In the Dashrep code:
#
#  Add the state abbreviation to the end of the
#  displayed version of the city name -- so that
#  it's clear which same-name city was found.
#  If the city is not in a recognized state or
#  province and if the two-letter country code is known,
#  append the country code to the end of the city
#  name.


#--------------------------------------------------
#  Write the orginal city-info line, possibly
#  with the state/province and country code changed.

        print $city_name_searchable . " " . uc( $state_or_province ) . " " . uc( $country_code ) . " " . $latitude . " " . $longitude . " " . $node_id . " " . $displayed_city_name . "\n" ;


#--------------------------------------------------
#  Repeat the loop that handles each line of city info.

    }
}


#--------------------------------------------------
#  Indicate which postal-code-source cities were
#  not matched.

open( OUTLOG , ">" . $log_file_name ) ;
foreach $combo_city_latitude_longitude ( keys( %not_found_combo ) )
{
    print OUTLOG "city not found: " . $combo_city_latitude_longitude . "\n" ;
}
print OUTLOG "\n\n" ;
foreach $combo_city_latitude_longitude ( keys( %found_combo ) )
{
    print OUTLOG ">> " . $combo_city_latitude_longitude . "\n" ;
}
