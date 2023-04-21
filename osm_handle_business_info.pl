#--------------------------------------------------
#       osm_handle_business_info.pl
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


#  Usage in Linux environment:
#
#  perl osm_handle_business_info.pl > output_log_osm_handle_business_info.txt


#--------------------------------------------------
#  Specify Linux or Windows path style.

$slash_or_backslash = "/" ;  # linux
$slash_or_backslash = "\\" ;  # windows


#--------------------------------------------------
#  Specify the input and output filenames.

$input_filename = 'output_business_info_all_nodes_ways_relations.txt' ;
$output_filename_frequency_counts = 'output_business_frequency_count_exceeded.txt' ;
$output_filename_filtered_business_info = 'output_businesses_filtered.txt' ;
$output_filename_promo_businesses_info = 'output_businesses_filtered_promo_type.txt' ;
$output_filename_links = 'output_businesses_links.txt' ;


#--------------------------------------------------
#  Specify how many businesses can have the same
#  domain name, and how many can have the same
#  business name, and the maximum length of a
#  website URL.

$threshold_count_for_domain_name = 7 ;
$threshold_count_for_business_name = 20 ;
$maximum_allowed_length_of_website_url = 140 ;


#--------------------------------------------------
#  Examples of input lines:
#
#    b 10508875000 09983816599 n271078 Acres_Down_Farm shop_tea no_web
#    b 10454676590 08772863862 w291415817 Annie_Bloom&#39;s_Books shop_books www.annieblooms.com


#--------------------------------------------------
#  Specify shorter names for some business types.

$business_type_short_for_business_type{ "shop_hardware" } = "hardware" ;
$business_type_short_for_business_type{ "shop_doityourself" } = "hardware" ;
$business_type_short_for_business_type{ "shop_books" } = "bookstore" ;

$business_type_short_for_business_type{ "shop_coffee" } = "cafe" ;
$business_type_short_for_business_type{ "shop_tea" } = "tea_shop" ;
$business_type_short_for_business_type{ "shop_chocolate" } = "chocolate_shop" ;
$business_type_short_for_business_type{ "shop_confectionery" } = "confectionery" ;
$business_type_short_for_business_type{ "shop_bakery" } = "bakery" ;
$business_type_short_for_business_type{ "shop_pastry" } = "bakery" ;
$business_type_short_for_business_type{ "shop_deli" } = "deli" ;

$business_type_short_for_business_type{ "shop_car_repair" } = "car_repair" ;
$business_type_short_for_business_type{ "shop_optician" } = "optician" ;
$business_type_short_for_business_type{ "shop_antiques" } = "antiques" ;
$business_type_short_for_business_type{ "shop_art" } = "art" ;
$business_type_short_for_business_type{ "shop_music" } = "music" ;
$business_type_short_for_business_type{ "shop_toys" } = "toy_store" ;
$business_type_short_for_business_type{ "shop_musical_instrument" } = "musical_instruments" ;

$business_type_short_for_business_type{ "amenity_cafe" } = "cafe" ;
$business_type_short_for_business_type{ "amenity_ice_cream" } = "ice_cream" ;
$business_type_short_for_business_type{ "amenity_restaurant" } = "restaurant" ;
$business_type_short_for_business_type{ "amenity_dentist" } = "dentist" ;
$business_type_short_for_business_type{ "amenity_biergarten" } = "biergarten" ;


#--------------------------------------------------
#  Specify default business types.

$yes_if_default_business_type{ "restaurant" } = "yes" ;
$yes_if_default_business_type{ "cafe" } = "yes" ;
$yes_if_default_business_type{ "deli" } = "yes" ;
$yes_if_default_business_type{ "bakery" } = "yes" ;
$yes_if_default_business_type{ "biergarten" } = "yes" ;
$yes_if_default_business_type{ "pastry" } = "yes" ;
$yes_if_default_business_type{ "tea_shop" } = "yes" ;

#  Include independent alternatives to Amazon, Starbucks, Home Depot

$yes_if_default_business_type{ "bookstore" } = "yes" ;
$yes_if_default_business_type{ "hardware" } = "yes" ;
$yes_if_default_business_type{ "doityourself" } = "yes" ;
$yes_if_default_business_type{ "coffee_shop" } = "yes" ;


#--------------------------------------------------
#  Specify the priority for businesses that are tagged
#  with multiple business types.

$business_type_for_priority[ 1 ] = "amenity_restaurant" ;
$business_type_for_priority[ 2 ] = "amenity_cafe" ;
$business_type_for_priority[ 3 ] = "shop_deli" ;
$business_type_for_priority[ 4 ] = "shop_bakery" ;
$business_type_for_priority[ 5 ] = "shop_pastry" ;
$business_type_for_priority[ 6 ] = "shop_tea" ;
$business_type_for_priority[ 7 ] = "amenity_biergarten" ;
$business_type_for_priority[ 8 ] = "shop_coffee" ;
$business_type_for_priority[ 9 ] = "shop_chocolate" ;
$business_type_for_priority[ 10 ] = "shop_confectionery" ;
$business_type_for_priority[ 11 ] = "amenity_ice_cream" ;
$business_type_for_priority[ 12 ] = "shop_books" ;
$business_type_for_priority[ 13 ] = "shop_hardware" ;
$business_type_for_priority[ 14 ] = "shop_doityourself" ;
$business_type_for_priority[ 15 ] = "shop_toys" ;
$business_type_for_priority[ 16 ] = "shop_music" ;
$business_type_for_priority[ 17 ] = "shop_musical_instrument" ;
$business_type_for_priority[ 18 ] = "shop_art" ;
$business_type_for_priority[ 19 ] = "shop_antiques" ;
$business_type_for_priority[ 20 ] = "amenity_dentist" ;
$business_type_for_priority[ 21 ] = "shop_optician" ;
$business_type_for_priority[ 22 ] = "shop_car_repair" ;
$max_priority = 22 ;

for ( $priority = 1 ; $priority <= $max_priority ; $priority ++ )
{
    $priority_for_business_type{ $business_type_for_priority[ $priority ] } = $priority ;
}


#--------------------------------------------------
#  Specify some naming variations for chain businesses.

$high_frequency_lowercase_business_name{ "sears_outlet" } = "y" ;
$high_frequency_lowercase_business_name{ "haggen_daaz" } = "y" ;
$high_frequency_lowercase_business_name{ "sherwin_williams" } = "y" ;
$high_frequency_lowercase_business_name{ "sherwin-williams" } = "y" ;


#--------------------------------------------------
#  Later, if too many businesses for this code to
#  identify chain businesses, split data by continent
#  using rough, simple, overlapping, bounding boxes.
#  Exact boundaries not needed.
#  Also, if needed, use one pass for domain names
#  and another pass for business names.


#--------------------------------------------------
#  Open the input file.
#
#  Reminder:  Cannot use STDIN because file is opened a second time.

open( INFILE , "<" . $input_filename ) ;


#--------------------------------------------------
#  Read each line in the file.

while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;


#--------------------------------------------------
#  If there are multiple business types specified
#  for a single business, choose the dominant
#  type.

    $highest_priority = 100 ;
    if ( $input_line =~ /^(.+)(( ((shop)|(amenity))_[^ ]+){2,})(.+)$/ )
    {
        $prefix = $1 ;
        $multiple_business_types = $2 ;
        $suffix = $7 ;
        $multiple_business_types =~ s/^ +// ;
#        print "multiple_business_types: " . $multiple_business_types . "\n" ;
        @list_of_business_types = split( / +/ , $multiple_business_types ) ;
        foreach $business_type ( @list_of_business_types )
        {
            if ( ( exists( $priority_for_business_type{ $business_type } ) ) && ( $priority_for_business_type{ $business_type } < $highest_priority ) )
            {
                $highest_priority = $priority_for_business_type{ $business_type } ;
            }
        }
        if ( $highest_priority < 100 )
        {
            $input_line = $prefix . " " . $business_type_for_priority[ $highest_priority ] . $suffix ;
        }
#        print "Revised line: " . $input_line . "\n" ;
    }


#--------------------------------------------------
#  Recognize the next business-info line.

    if ( $input_line =~ /^b? *([0-9]+ [0-9]+) ([nwr][0-9]+) ([^ ]+) ([^ ]+) ([^ ]+)/ )
    {
        $location_info = $1 ;
        $business_id = $2 ;
        $business_name = $3 ;
        $business_type = $4 ;
        $website_url = $5 ;


#--------------------------------------------------
#  Within a business name, or a website URL,
#  convert a "full stop" into a period, and
#  convert Unicode 58 into ":" character.

        $business_name =~ s/&#46;/\./g ;
        $business_name =~ s/&#58;/:/g ;
        $website_url =~ s/&#46;/\./g ;
        $website_url =~ s/&#58;/:/g ;


#--------------------------------------------------
#  Count the number of occurances of each business
#  name, for the purpose of identifying
#  chain/franchise businesses.
#  Use the lowercase version to match the same
#  name with different capitalization.
#  Omit an apostrophe character (or the backwards
#  look-alike character), so that
#  Tim_Horton's and Tim_Hortons are matched.
#
#  If changes are made here, also change the same
#  code later in this script.

        $lowercase_business_name = lc( $business_name ) ;
        $lowercase_business_name =~ s/&#39;//g ;
        $lowercase_business_name =~ s/&#96;//g ;
        $lowercase_business_name =~ s/'//g ;
        $count_for_lowercase_business_name{ $lowercase_business_name } ++ ;


#--------------------------------------------------
#  Filter out some high-frequency business names
#  based on finding the name anywhere within the full name.
#  Examples:
#    McDonalds_restaurant
#    variations on punctuation
#    PIZZA_HUT&#24517;&#21213;&#23458;-&#21488;&#20013;&#22823;&#37324;&#22615;&#22478;&#24215;
#    Taco_Bell&#47;Pizza_Hut
#    Pizza_Hut_Delivery
#  Also exclude comic-book stores and Christian Science "bookstores."

        if ( $lowercase_business_name =~ /chuck[-_]e[-_]cheese/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /starbucks?/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /amazon_bookstore/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /home_depot/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /mcdonalds/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /pizza_hut/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /tim_hortons/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /dunkin_donuts/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /applebees/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /dutch[-_]bro/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /carls_((jr)|(junior))/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /ben_&_jerry/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /sherwin[-_]williams/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /barnes_&_noble/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /christian_science/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /comic_books/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /taco_bell/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /tacobell/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        } elsif ( $lowercase_business_name =~ /kentucky_fried_chicken/ )
        {
            $yes_or_no_exclude_business_name{ $lowercase_business_name } = "yes" ;
        }


#--------------------------------------------------
#  Count the number of occurances of each website
#  domain name -- for the purpose of identifying
#  chain/franchise businesses.
#
#  This code may not correctly handle Unicode
#  characters.

#  Domain name patterns according to StackOverflow:

# ^((?!-))(xn--)?[a-z0-9][a-z0-9-_]{0,61}[a-z0-9]{0,1}\.(xn--)?([a-z0-9\-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,})$

# ^(([a-zA-Z]{1})|([a-zA-Z]{1}[a-zA-Z]{1})|([a-zA-Z]{1}[0-9]{1})|([0-9]{1}[a-zA-Z]{1})|([a-zA-Z0-9][a-zA-Z0-9-_]{1,61}[a-zA-Z0-9]))\.([a-zA-Z]{2,6}|[a-zA-Z0-9-]{2,30}\.[a-zA-Z]{2,6})$

        if ( $website_url =~ /acehardware\.com/i )
        {
            $website_url = "no_web" ;
        }
        if ( $website_url ne "no_web" )
        {
#  if this code is edited, also edit copy farther below
            $website_domain_name = lc( $website_url ) ;
            if ( $website_domain_name =~ /([a-z0-9_\-\.]+\.[a-z0-9_\-\.]+)/ )
            {
                $website_domain_name = $1 ;
                $website_domain_name =~ s/^www\.// ;
                if ( length( $website_domain_name ) > 1 )
                {
                    $count_for_website_domain_name{ $website_domain_name } ++ ;
                }
            }
            $count_for_website_domain_name{ $website_url } ++ ;
        }


#--------------------------------------------------
#  Repeat the loop for the next line in the file.

    }
}


#--------------------------------------------------
#  Close the input file.

close( INFILE ) ;


#--------------------------------------------------
#  Open the output file that logs which businesses
#  are recognized as chain businesses.

open( FREQ_FILE , ">" . $output_filename_frequency_counts ) ;

if ( $debug_info =~ /[^ ]/ )
{
    print FREQ_FILE $debug_info . "\n\n\n" ;
}


#--------------------------------------------------
#  For logging purposes, write the sorted counts
#  of the business names and website domain names
#  that will be excluded.

print FREQ_FILE "High-frequency domain names, followed by business names, that will be excluded:" . "\n\n\n" ;

foreach $website_domain_name ( keys( %count_for_website_domain_name ) )
{
    $count = $count_for_website_domain_name{ $website_domain_name } ;
    if ( $count > $threshold_count_for_domain_name )
    {
        $high_frequency_website_domain_name{ $website_domain_name } = "y" ;
        $website_domain_names_at_count{ $count } .= $website_domain_name . "  " . $count . "\n" ;
    }
}
foreach $count ( sort {$b <=> $a} keys( %website_domain_names_at_count ) )
{
    print FREQ_FILE $website_domain_names_at_count{ $count } ;
}
%website_domain_names_at_count = ( ) ;

print FREQ_FILE "\n\n\n" ;

foreach $lowercase_business_name ( keys( %count_for_lowercase_business_name ) )
{
    $count = $count_for_lowercase_business_name{ $lowercase_business_name } ;
    if ( ( $count > $threshold_count_for_business_name ) && ( $lowercase_business_name !~ /ace_hardware/ ) )
    {
        $high_frequency_lowercase_business_name{ $lowercase_business_name } = "y" ;
        $business_names_at_count{ $count } .= $lowercase_business_name . "  " . $count . "\n" ;
    }
}
foreach $count ( sort {$b <=> $a} keys( %business_names_at_count ) )
{
    print FREQ_FILE $business_names_at_count{ $count } ;
}
%business_names_at_count = ( ) ;


#--------------------------------------------------
#  Create the output files that will contain the
#  filtered list of business info.

open( OUT_FILE , ">" . $output_filename_filtered_business_info ) ;
open( OUT_FILE_PROMO_TYPE , ">" . $output_filename_promo_businesses_info ) ;


#--------------------------------------------------
#  Re-open the input file and read the businesses
#  again.

open( INFILE , "<" . $input_filename ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^b? *([0-9]+ [0-9]+) ([nwr][0-9]+) ([^ ]+) ([^ ]+) ([^ ]+)/ )
    {
        $location_info = $1 ;
        $business_id = $2 ;
        $business_name = $3 ;
        $business_type = $4 ;
        $website_url = $5 ;


#--------------------------------------------------
#  Again, convert a "full stop" into a period, and
#  convert Unicode 58 into ":" character.

        $business_name =~ s/&#46;/\./g ;
        $business_name =~ s/&#58;/:/g ;
        $website_url =~ s/&#46;/\./g ;
        $website_url =~ s/&#58;/:/g ;
#        $website_url =~ s/&58;/:/g ;


#--------------------------------------------------
#  Filter out businesses with specific domain
#  names.  Also ignore URLs that point to Google
#  or Facebook.

        $yes_or_no_write_this_business = "yes" ;
        if ( $website_url =~ /((starbucks)|(mcdonalds)|(olivegarden)|(homedepot)|(dunkin)|(timhortons)|(pizzahut)|(outbacksteakhouse))/i )
        {
            $website_url = "no_web" ;
            $yes_or_no_write_this_business = "no" ;
        }
        if ( $website_url =~ /((facebook)|(google))/i )
        {
            $website_url = "no_web" ;
        }


#--------------------------------------------------
#  Possibly revise website URL and/or filter out
#  high-frequency domain names.
#  Ignore acehardware.com domain names, but do not
#  filter out those businesses.

        if ( $website_url =~ /acehardware\.com/i )
        {
            $website_url = "no_web" ;
        }
        if ( length( $website_url ) > $maximum_allowed_length_of_website_url )
        {
            $website_url = "no_web" ;
        }
        if ( $website_url eq "no_web" )
        {
            $website_url_with_leading_space_if_not_empty = "" ;
        } else
        {
            $website_url_with_leading_space_if_not_empty = $website_url ;
            $website_url_with_leading_space_if_not_empty = " " . $website_url_with_leading_space_if_not_empty ;
        }
        if ( $website_url_with_leading_space_if_not_empty ne "" )
        {
#  if this code is edited, also edit copy above
            $website_domain_name = lc( $website_url ) ;
            if ( $website_domain_name =~ /([a-z0-9_\-\.]+\.[a-z0-9_\-\.]+)/ )
            {
                $website_domain_name = $1 ;
                $website_domain_name =~ s/^www\.// ;
                if ( length( $website_domain_name ) > 1 )
                {
                    if ( ( exists( $high_frequency_website_domain_name{ $website_domain_name } ) ) || ( exists( $high_frequency_website_domain_name{ $website_url } ) ) )
                    {
                        $yes_or_no_write_this_business = "no" ;
                    }
                }
            }
        }


#--------------------------------------------------
#  Exclude high-frequency business names.
#  Ignore punctuation when doing this check.

        $lowercase_business_name = lc( $business_name ) ;
        $lowercase_business_name =~ s/&#39;//g ;
        $lowercase_business_name =~ s/&#96;//g ;
        $lowercase_business_name =~ s/'//g ;
        if ( exists( $high_frequency_lowercase_business_name{ $lowercase_business_name } ) )
        {
            $yes_or_no_write_this_business = "no" ;
        }
        if ( exists( $yes_or_no_exclude_business_name{ $lowercase_business_name } ) )
        {
            $yes_or_no_write_this_business = "no" ;
        }


#--------------------------------------------------
#  Allow "Ace Hardware" businesses because many of
#  them are family-owned businesses.  (They buy
#  products through the Ace co-op because
#  otherwise there are no other wholesale hardware
#  businesses.)   Do NOT include True Value
#  hardware stores because most of those stores
#  are franchise businesses.
#  Ensure that "Horace Hardware" will not match.

        if ( ( $business_name =~ /^ace_hardware/i ) || ( $business_name =~ /[^a-z]ace_hardware/i ) )
        {
            $yes_or_no_write_this_business = "yes" ;
            $business_type = "shop_hardware" ;
        }
        if ( $website_url =~ /acehardware\.com/i )
        {
            $website_url = "no_web" ;
            $yes_or_no_write_this_business = "yes" ;
            $business_type = "shop_hardware" ;
        }


#--------------------------------------------------
#  Write the info for the non-excluded businesses.
#  The "promo" businesses are written to a separate
#  file, and will be used only if they are being
#  promoted.

        if ( $yes_or_no_write_this_business eq "yes" )
        {

#  if ( $website_url =~ /\.com/ )
#  {
#    print $input_line . "  " . $website_url . "  " . $website_domain_name . "\n" ;
#  }

            if ( exists( $business_type_short_for_business_type{ $business_type } ) )
            {
                $business_type = $business_type_short_for_business_type{ $business_type } ;
            }
            $info = "b " . $location_info . " " . $business_id . " " . $business_name . " " . $business_type . $website_url_with_leading_space_if_not_empty . "\n" ;
            if ( exists( $yes_if_default_business_type{ $business_type } ) )
            {
                print OUT_FILE $info ;
            } else
            {
                print OUT_FILE_PROMO_TYPE $info ;
            }
        }
    }
}

