#--------------------------------------------------
#    convert_postal_code_database.pl
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


#--------------------------------------------------
#  Data input is "all_countries" zipped CSV file
#  from the GeoNames.org website.  To get it,
#  click on the
#  "Download, Free Postal Code Data" link
#  on the main page, then scroll down to the
#  "all_countries.zip" (zipped CSV) file and
#  download it using the Firefox browser, then
#  unzip it, and rename it to:
#  PostalCodesAllCountriesLatest.txt
#
#  Then use the script
#  "convert_tab_delimited_to_quoted_csv.pl"
#  first, then use this script.  See the
#  osm_processing_do_all.pl script for usage.


#--------------------------------------------------
#  Open the output files.

open( OUTCODES , ">" . "output_postal_code_info_ready_to_split.txt" ) ;
open( OUTCITY , ">" . "output_state_country_abbreviations_for_each_city.txt" ) ;


#--------------------------------------------------
#  Get each line of info from the input file,
#  which is uses the quoted CSV (comma-separated
#  values) format.
#
#  Ignore a city name or state name that begins
#  with a digit.

while ( $input_line = <STDIN> ) {
    chomp ( $input_line ) ;
    if ( $input_line =~ /"([A-Z][A-Z])","([^"]*[0-9][^"]+[^"]*)","([^"0-9][^"]*)","([^"0-9][^"]*)","([^"]*)","[^"]*","[^"]*","[^"]*","[^"]*","([\-0-9\.]+)","([\-0-9\.]+)"/ )
    {
        $country_code = $1 ;
        $postal_code = $2 . "" ;
        $city = $3 ;
        $state = $4 ;
        $state_abbreviation = $5 ;
        $latitude = $6 ;
        $longitude = $7 ;
        if ( $state_abbreviation eq "" )
        {
            $state_abbreviation = "??" ;
        }


#--------------------------------------------------
#  Convert the city name into a single word.

        $city =~ s/^ +// ;
        $city =~ s/ +$// ;
        $city =~ s/ +/_/g ;


#--------------------------------------------------
#  In the postal code, convert dashes
#  and spaces to underscores.

        $postal_code =~ s/-/_/g ;
        $postal_code =~ s/ +/_/g ;


#--------------------------------------------------
#  Convert the city name into a standardized
#  version.

        $name = $city ;
        &generate_standardized_name( ) ;
        $city = $name ;


#--------------------------------------------------
#  If needed, in the log file, show the first
#  line of each country info.

#        if ( $displayed_country_code{ $country_code } ne "yes" )
#        {
#            print $input_line . "\n" ;
#            $displayed_country_code{ $country_code } = "yes" ;
#        }


#--------------------------------------------------
#  Convert the latitude and longitude to nines
#  complement numbers.

        $latitude_without_minus = $latitude ;
        $latitude_without_minus =~ s/-//g ;
        $latitude_nines_complement_truncated = sprintf( "%010d" , int( $latitude_without_minus * 10000000 ) ) ;
        if ( substr( $latitude , 0 , 1 ) eq "-" )
        {
            $latitude_nines_complement_truncated =~ tr/0123456789/9876543210/ ;
            $latitude_nines_complement = "0" . $latitude_nines_complement_truncated ;
        } else
        {
            $latitude_nines_complement = "1" . $latitude_nines_complement_truncated ;
        }

        $longitude_without_minus = $longitude ;
        $longitude_without_minus =~ s/-//g ;
        $longitude_nines_complement_truncated = sprintf( "%010d" , int( $longitude_without_minus * 10000000 ) ) ;
        if ( substr( $longitude , 0 , 1 ) eq "-" )
        {
            $longitude_nines_complement_truncated =~ tr/0123456789/9876543210/ ;
            $longitude_nines_complement = "0" . $longitude_nines_complement_truncated ;
        } else
        {
            $longitude_nines_complement = "1" . $longitude_nines_complement_truncated ;
        }


#--------------------------------------------------
#  Accumulate the info using a different storage
#  area for each country.  For each city outside
#  the US and Canada, add an extra line that
#  appends the country code to the end of the
#  city name.  If the city is in the US (USA)
#  or CA (Canada), append state or province in
#  addition to the country code.
#  This convention allows choosing between
#  cities that have the same name, such as
#  Vancouver BC and Vancouver WA.

        $city_and_state_and_country = lc( $city ) . " " . lc( $state_abbreviation ) . " " . lc( $country_code ) ;
        $city_for_city_and_state_and_country{ $city_and_state_and_country } = $city ;
        $state_abbreviation_for_city_and_state_and_country{ $city_and_state_and_country } = $state_abbreviation ;
        $lines_for_country_code{ $country_code } .= lc( $postal_code ) . " " . $latitude_nines_complement . " " . $longitude_nines_complement . " " . $city ;
        if ( ( $country_code eq "US" ) || ( $country_code eq "CA" ) )
        {
            $lines_for_country_code{ $country_code } .= "_" . $state_abbreviation ;
        } else
        {
            $lines_for_country_code{ $country_code } .= "_" . $country_code ;
        }
        $lines_for_country_code{ $country_code } .= "\n" ;


#--------------------------------------------------
#  Do some counting and summation, which will be
#  used to calculate the average latitude and longitude.
#  The latitude and longitude provided in the OSM data
#  will be used for the website.  These numbers are for
#  the purpose of correctly matching multiple cities
#  that have the same name.  In turn, this information
#  is used to determine country codes for cities in
#  the OSM data that do not include country codes (which
#  applies to most city nodes in the OSM data).

        $count_of_postal_codes_in_city{ $city_and_state_and_country } ++ ;
        $sum_of_latitudes{ $city_and_state_and_country } += $latitude_nines_complement ;
        $sum_of_longitudes{ $city_and_state_and_country } += $longitude_nines_complement ;


#--------------------------------------------------
#  Repeat the loop to handle the next line of info.

    }
}


#--------------------------------------------------
#  Specify the sequence of country codes in the
#  order in which the codes will be recognized.
#
#  Do NOT include the following because they also
#  use 5-digit postal codes:
#      AS AX DE DZ ES FI FR GF GT GU HR IT TH TR VI YT MC MH MP MQ MX MY PK PM GP RE
#
#  The following countries use 4-digit codes, so just
#  specify one of them in the list:
#      AU AR AT BE BG CH DK HU NL NO LI SJ
#
#  The following countries use 6-digit codes, so just
#  specify one of them in the list:
#      IN RO RU 

@list_of_country_codes = ( "US" , "PR " , "CA" , "GB" , "JP" , "AU" , "IN" , "MD" , "PL" , "PT" , "SE" , "BR" ) ;


#--------------------------------------------------
#  Write the results.

foreach $country_code ( @list_of_country_codes )
{
    print OUTCODES $lines_for_country_code{ $country_code } ;
}


#--------------------------------------------------
#  Create searchable versions of the city names, which
#  include the state abbreviation and country code.
#  Also write the average of the latitude and longitude
#  for each city.

foreach $city_and_state_and_country ( sort( keys( %count_of_postal_codes_in_city ) ) )
{
    $city = $city_for_city_and_state_and_country{ $city_and_state_and_country } ;
    $state_abbreviation = $state_abbreviation_for_city_and_state_and_country{ $city_and_state_and_country } ;
    $country_code = substr( $city_and_state_and_country , -2 , 2 ) ;
    $postal_code_count = $count_of_postal_codes_in_city{ $city_and_state_and_country } ;
    $average_latitude = sprintf( "%011d" , int( $sum_of_latitudes{ $city_and_state_and_country } / $postal_code_count ) ) ;
    $average_longitude = sprintf( "%011d" , int( $sum_of_longitudes{ $city_and_state_and_country } / $postal_code_count ) ) ;
    $string_with_info = lc( $city ) . " " . lc( $state_abbreviation ) . " " . lc( $country_code ) . " " . $average_latitude . " " . $average_longitude ;
    if ( not( exists( $exists_string_with_info{ $string_with_info } ) ) )
    {
        print OUTCITY $string_with_info . "\n" ;
        $exists_string_with_info{ $string_with_info } = "y" ;
    }
}


#--------------------------------------------------
#--------------------------------------------------
#
#  The following subroutine was copied from
#  osm_split_and_abbrev_node_way_relation.pl
#  and must not be edited.
#  If the original is changed, this copy should
#  be re-copied.
#
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
#  "&#39;", with the ASCII equivalent.

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

    $name =~ s/-/_/g ;


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
