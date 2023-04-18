#--------------------------------------------------
#       osm_handle_city_info.pl
#--------------------------------------------------

#  (c) Copyright 2014-2015 by Richard Fobes at SolutionsCreative.com



#--------------------------------------------------
#  Sample input data:

#  001 ??? ?? ?? 10399636446 09234633634 w1081900549 ???

#  10142769353 09889480836 n10 Mamassita no_label alt_name_Mamacita lang_count_0 place_village no_is_in
#  10550288307 10829226887 n54 &#1053;&#1086;&#1074;&#1086;&#1089;&#1080;&#1073;&#1080;&#1088;&#1089;&#1082; no_label name&#58;en_Novosibirsk lang_count_33 admin_level_3 place_city population_1621330 no_is_in
#  10407644228 09260076081 n666 Hell&#39;s_Kitchen no_label alt_name_Clinton lang_count_7 place_neighbourhood no_is_in
#  10515073359 09998723499 n107775 London no_label name&#58;en_London lang_count_250 admin_level_2 place_city population_8908083 is_in:country_code_GB is_in:iso_3166_2_GB-ENG
#  10520027574 10011820034 n132591 Woolverstone no_label no_alt_name lang_count_0 place_village no_is_in
#  10519899040 10012087457 n132593 Chelmondiston no_label no_alt_name lang_count_0 place_village no_is_in
#  10516503583 10005181949 n132634 South_Hanningfield no_label no_alt_name lang_count_0 place_village is_in:country_UK is_in:county_Essex
#  10516709118 10005001963 n132635 West_Hanningfield no_label no_alt_name lang_count_0 place_village is_in:country_UK is_in:county_Essex

#  10457924182 10031604028 w33040728 ??? no_label no_alt_name lang_count_0 admin_level_8 boundary_administrative no_is_in
#  10697857405 08371343629 w33040742 Point_Lay no_label no_alt_name lang_count_0 boundary_administrative is_in:country_code_US is_in:iso_3166_2_US_AK is_in:state_Alaska is_in:state_code_AK
#  10340368580 08895173019 w33040801 Cibecue no_label no_alt_name lang_count_0 boundary_administrative is_in:country_code_US is_in:iso_3166_2_US_AZ is_in:state_Arizona is_in:state_code_AZ
#  10509345670 10079466266 w33040856 Meiswinkel no_label no_alt_name lang_count_0 place_village population_634 no_is_in
#  10458378221 10031768933 w33040902 ??? no_label no_alt_name lang_count_0 admin_level_7 boundary_administrative no_is_in
#  10353956305 08896816184 w33040906 Dilkon no_label no_alt_name lang_count_0 boundary_administrative is_in:country_code_US is_in:iso_3166_2_US_AZ is_in:state_Arizona is_in:state_code_AZ
#  10338064610 08900753579 w33040934 East_Fork no_label no_alt_name lang_count_0 boundary_administrative is_in:country_code_US is_in:iso_3166_2_US_AZ is_in:state_Arizona is_in:state_code_AZ

#  10513971329 10092489713 r4155509 Escheberg no_alt_name lang_count_0 admin_level_9 boundary_administrative population_25 no_is_in
#  10529764800 09939006104 r4155645 Ballynabarney no_label alt_name_Ballynabarny_name&#58;en_Ballynabarny lang_count_2 admin_level_10 boundary_administrative no_is_in
#  10529667116 09938669522 r4155527 Ballymanus_Lower no_label name&#58;en_Ballymanus_Lower lang_count_2 admin_level_10 boundary_administrative no_is_in
#  10529737788 09938342113 r4155528 Ballymanus_Upper no_label name&#58;en_Ballymanus_Upper lang_count_2 admin_level_10 boundary_administrative no_is_in
#  10514067904 10092803461 r4155538 Laar no_alt_name lang_count_0 admin_level_9 boundary_administrative population_25 no_is_in
#  10518234620 09987114682 r4155570 Kidlington no_alt_name lang_count_0 admin_level_10 boundary_administrative no_is_in
#  10529758110 09938755665 r4155585 Ballykillavane no_label name&#58;en_Ballykillavane lang_count_2 admin_level_10 boundary_administrative no_is_in
#  10529779423 09938459412 r4155586 Ballyknockan_More no_label name&#58;en_Ballyknockan_More lang_count_1 admin_level_10 boundary_administrative no_is_in
#  10529832615 09938686822 r4155587 Coolnakilly no_label name&#58;en_Coolnakilly lang_count_2 admin_level_10 boundary_administrative no_is_in
#  10513754414 10092370466 r4155615 Oberelsungen no_alt_name lang_count_0 admin_level_9 boundary_administrative population_1267 no_is_in
#  10513678614 10093001694 r4155621 Zierenberg no_alt_name lang_count_0 admin_level_9 boundary_administrative no_is_in
#  10518231826 09987635963 r4155651 Islip no_alt_name lang_count_0 admin_level_10 boundary_administrative no_is_in
#  10533425738 09933334165 r4155660 Raheen no_label name&#58;en_Raheen lang_count_1 admin_level_10 boundary_administrative no_is_in
#  10154263647 10756300786 r4155661 Gadag_taluk no_alt_name lang_count_1 admin_level_6 boundary_administrative no_is_in
#  10443239037 10189174686 r14535302 &#1057;&#1077;&#1083;&#1080;&#1096;&#1090;&#1077; name&#58;en_Seliste lang_count_2 admin_level_9 boundary_administrative no_is_in


#--------------------------------------------------
#  Sample output data:

#  005 mamassita ?? ?? 10142769353 09889480836 n10 Mamassita
#  005 mamacita ?? ?? 10142769353 09889480836 n10 Mamassita
#  056 novosibirsk ?? ?? 10550288307 10829226887 n54 &#1053;&#1086;&#1074;&#1086;&#1089;&#1080;&#1073;&#1080;&#1088;&#1089;&#1082;
#  056 &#1053;&#1086;&#1074;&#1086;&#1089;&#1080;&#1073;&#1080;&#1088;&#1089;&#1082; ?? ?? 10550288307 10829226887 n54 &#1053;&#1086;&#1074;&#1086;&#1089;&#1080;&#1073;&#1080;&#1088;&#1089;&#1082;
#  011 clinton ?? ?? 10407644228 09260076081 n666 Hell&#39;s_Kitchen
#  011 hell&#39;s_kitchen ?? ?? 10407644228 09260076081 n666 Hell&#39;s_Kitchen
#  059 london ?? GB 10515073359 09998723499 n107775 London
#  005 woolverstone ?? ?? 10520027574 10011820034 n132591 Woolverstone
#  005 chelmondiston ?? ?? 10519899040 10012087457 n132593 Chelmondiston
#  005 south_hanningfield ?? GB 10516503583 10005181949 n132634 South_Hanningfield
#  005 west_hanningfield ?? GB 10516709118 10005001963 n132635 West_Hanningfield
#  005 netheravon ?? ?? 10512385525 09982064777 n134366 Netheravon


#--------------------------------------------------
#  Specify the output filenames.

$output_filename_processed_city_info = 'output_processed_city_info.txt' ;
$output_filename_country_codes = 'output_processed_country_codes.txt' ;
$output_filename_duplicate_city_names = 'output_duplicate_city_names_searchable.txt' ;


#--------------------------------------------------
#  Specify rank scores for the city types.

$rank_score_for_city_type{ "place_city" } = 8 ;
$rank_score_for_city_type{ "boundary_type_city" } = 8 ;
$rank_score_for_city_type{ "border_type_city" } = 8 ;

$rank_score_for_city_type{ "place_town" } = 7 ;
$rank_score_for_city_type{ "boundary_type_town" } = 7 ;
$rank_score_for_city_type{ "border_type_township" } = 7 ;

$rank_score_for_city_type{ "place_suburb" } = 6 ;

$rank_score_for_city_type{ "place_municipality" } = 5 ;
$rank_score_for_city_type{ "place_borough" } = 5 ;
$rank_score_for_city_type{ "place_quarter" } = 5 ;

$rank_score_for_city_type{ "place_village" } = 4 ;
$rank_score_for_city_type{ "border_type_village" } = 4 ;

$rank_score_for_city_type{ "place_neighbourhood" } = 3 ;

$rank_score_for_city_type{ "place_hamlet" } = 2 ;

$rank_score_for_city_type{ "boundary_administrative" } = 1 ;


#--------------------------------------------------
#  Allow for multiple names for specific countries.

$country_code_for_country_name{ "UK" } = "gb" ;
$country_code_for_country_name{ "United_Kingdom" } = "gb" ;
$country_code_for_country_name{ "England" } = "gb" ;
$country_code_for_country_name{ "Russia" } = "ru" ;
$country_code_for_country_name{ "Russian_Federation" } = "ru" ;
$country_code_for_country_name{ "Denmark" } = "dk" ;
$country_code_for_country_name{ "Danmark" } = "dk" ;
$country_code_for_country_name{ "Germany" } = "de" ;
$country_code_for_country_name{ "Deutschland" } = "de" ;
$country_code_for_country_name{ "Brazil" } = "br" ;
$country_code_for_country_name{ "Brasil" } = "br" ;
$country_code_for_country_name{ "Espana" } = "es" ;

$country_name_for_country_code{ "gb" } = "UK" ;
$country_name_for_country_code{ "ru" } = "Russia" ;
$country_name_for_country_code{ "dk" } = "Denmark" ;
$country_name_for_country_code{ "de" } = "Deutschland" ;
$country_name_for_country_code{ "br" } = "Brazil" ;
$country_name_for_country_code{ "es" } = "Spain" ;


#--------------------------------------------------
#  Inserted lookup codes from previous executions
#  of this script.
#
#  They are needed here because the lookup
#  association might occur (in the data) after a
#  city that needs the lookup info.
#
#  Converters:
#  https://online-toolz.com/tools/text-html-entities-convertor.php
#  https://mothereff.in/html-entities
#  https://onlineunicodetools.com/convert-unicode-to-html

# $country_code_for_country_name{ "Curaçao" } = "cw" ;
$country_code_for_country_name{ "Cura&#231;ao" } = "cw" ;

# $country_code_for_country_name{ "Côte_d'Ivoire" } = "ci" ;
$country_code_for_country_name{ "C&#244;te_d&#39;Ivoire" } = "ci" ;

# $country_code_for_country_name{ "România" } = "ro" ;
$country_code_for_country_name{ "Rom&#226;nia" } = "ro" ;

# $country_code_for_country_name{ "България" } = "bg" ;
$country_code_for_country_name{ "&#1041;&#1098;&#1083;&#1075;&#1072;&#1088;&#1080;&#1103" } = "bg" ;

# $country_code_for_country_name{ "中華民國" } = "tw" ;
$country_code_for_country_name{ "&#20013;&#33775;&#27665;&#22283;" } = "tw" ;

$country_code_for_country_name{ "Afghanistan" } = "af" ;
$country_code_for_country_name{ "Albania" } = "al" ;
$country_code_for_country_name{ "Algeria" } = "dz" ;
$country_code_for_country_name{ "Angola" } = "ao" ;
$country_code_for_country_name{ "Argentina" } = "ar" ;
$country_code_for_country_name{ "Armenia" } = "am" ;
$country_code_for_country_name{ "Australia" } = "au" ;
$country_code_for_country_name{ "Austria" } = "at" ;
$country_code_for_country_name{ "Azerbaijan" } = "az" ;
$country_code_for_country_name{ "Bahamas" } = "bs" ;
$country_code_for_country_name{ "Bahrain" } = "bh" ;
$country_code_for_country_name{ "Bangladesh" } = "bd" ;
$country_code_for_country_name{ "Barbados" } = "bb" ;
$country_code_for_country_name{ "Belarus" } = "by" ;
$country_code_for_country_name{ "Belgium" } = "be" ;
$country_code_for_country_name{ "Belize" } = "bz" ;
$country_code_for_country_name{ "Benin" } = "bj" ;
$country_code_for_country_name{ "Bhutan" } = "bt" ;
$country_code_for_country_name{ "Bolivia" } = "bo" ;
$country_code_for_country_name{ "Bosnia_and_Herzegovina" } = "ba" ;
$country_code_for_country_name{ "Botswana" } = "bw" ;
$country_code_for_country_name{ "Brazil" } = "br" ;
$country_code_for_country_name{ "British_Indian_Ocean_Territory" } = "io" ;
$country_code_for_country_name{ "Bulgaria" } = "bg" ;
$country_code_for_country_name{ "Burkina_Faso" } = "bf" ;
$country_code_for_country_name{ "Burundi" } = "bi" ;
$country_code_for_country_name{ "Cambodia" } = "kh" ;
$country_code_for_country_name{ "Cameroon" } = "cm" ;
$country_code_for_country_name{ "Cape_Verde" } = "cv" ;
$country_code_for_country_name{ "Cayman_Islands" } = "ky" ;
$country_code_for_country_name{ "Central_African_Republic" } = "cf" ;
$country_code_for_country_name{ "Chad" } = "td" ;
$country_code_for_country_name{ "Chile" } = "cl" ;
$country_code_for_country_name{ "China" } = "cn" ;
$country_code_for_country_name{ "Colombia" } = "co" ;
$country_code_for_country_name{ "Comoros" } = "km" ;
$country_code_for_country_name{ "Congo" } = "cg" ;
$country_code_for_country_name{ "Congo-Kinshasa" } = "cd" ;
$country_code_for_country_name{ "Cook_Islands" } = "ck" ;
$country_code_for_country_name{ "Costa_Rica" } = "cr" ;
$country_code_for_country_name{ "Croatia" } = "hr" ;
$country_code_for_country_name{ "Cuba" } = "cu" ;
$country_code_for_country_name{ "Cyprus" } = "cy" ;
$country_code_for_country_name{ "Czech_Republic" } = "cz" ;
$country_code_for_country_name{ "Denmark" } = "dk" ;
$country_code_for_country_name{ "Deutschland" } = "de" ;
$country_code_for_country_name{ "Djibouti" } = "dj" ;
$country_code_for_country_name{ "Dominican_Republic" } = "do" ;
$country_code_for_country_name{ "Ecuador" } = "ec" ;
$country_code_for_country_name{ "Ecuatorial_Guinea" } = "cq" ;
$country_code_for_country_name{ "Egypt" } = "eg" ;
$country_code_for_country_name{ "El_Salvador" } = "sv" ;
$country_code_for_country_name{ "Eritrea" } = "er" ;
$country_code_for_country_name{ "Estonia" } = "ee" ;
$country_code_for_country_name{ "Ethiopia" } = "et" ;
$country_code_for_country_name{ "Falkland_Islands" } = "fk" ;
$country_code_for_country_name{ "Faroe_Islands" } = "fo" ;
$country_code_for_country_name{ "Federated_States_of_Micronesia" } = "fm" ;
$country_code_for_country_name{ "Fiji" } = "fj" ;
$country_code_for_country_name{ "Finland" } = "fi" ;
$country_code_for_country_name{ "France" } = "fr" ;
$country_code_for_country_name{ "French_Guiana" } = "gf" ;
$country_code_for_country_name{ "French_Polynesia" } = "pf" ;
$country_code_for_country_name{ "Gabon" } = "ga" ;
$country_code_for_country_name{ "Gambia" } = "gm" ;
$country_code_for_country_name{ "Georgia" } = "ge" ;
$country_code_for_country_name{ "Ghana" } = "gh" ;
$country_code_for_country_name{ "Greece" } = "gr" ;
$country_code_for_country_name{ "Greenland" } = "gl" ;
$country_code_for_country_name{ "Grenada" } = "gd" ;
$country_code_for_country_name{ "Guatemala" } = "gt" ;
$country_code_for_country_name{ "Guinea-Bissau" } = "gw" ;
$country_code_for_country_name{ "Guinea" } = "gn" ;
$country_code_for_country_name{ "Guyana" } = "gy" ;
$country_code_for_country_name{ "Haiti" } = "ht" ;
$country_code_for_country_name{ "Honduras" } = "hn" ;
$country_code_for_country_name{ "Hungary" } = "hu" ;
$country_code_for_country_name{ "Iceland" } = "is" ;
$country_code_for_country_name{ "India" } = "in" ;
$country_code_for_country_name{ "Indonesia" } = "id" ;
$country_code_for_country_name{ "Iran" } = "ir" ;
$country_code_for_country_name{ "Iraq" } = "iq" ;
$country_code_for_country_name{ "Ireland" } = "ie" ;
$country_code_for_country_name{ "Israel" } = "il" ;
$country_code_for_country_name{ "Italy" } = "it" ;
$country_code_for_country_name{ "Jamaica" } = "jm" ;
$country_code_for_country_name{ "Japan" } = "jp" ;
$country_code_for_country_name{ "Jordan" } = "jo" ;
$country_code_for_country_name{ "Kazakhstan" } = "kz" ;
$country_code_for_country_name{ "Kenya" } = "ke" ;
$country_code_for_country_name{ "Kosovo" } = "xk" ;
$country_code_for_country_name{ "Kuwait" } = "kw" ;
$country_code_for_country_name{ "Kyrgyzstan" } = "kg" ;
$country_code_for_country_name{ "Laos" } = "la" ;
$country_code_for_country_name{ "Latvia" } = "lv" ;
$country_code_for_country_name{ "Lebanon" } = "lb" ;
$country_code_for_country_name{ "Lesotho" } = "ls" ;
$country_code_for_country_name{ "Liberia" } = "lr" ;
$country_code_for_country_name{ "Libya" } = "ly" ;
$country_code_for_country_name{ "Lithuania" } = "lt" ;
$country_code_for_country_name{ "Macedonia" } = "mk" ;
$country_code_for_country_name{ "Madagascar" } = "mg" ;
$country_code_for_country_name{ "Malawi" } = "mw" ;
$country_code_for_country_name{ "Malaysia" } = "my" ;
$country_code_for_country_name{ "Mali" } = "ml" ;
$country_code_for_country_name{ "Malta" } = "mt" ;
$country_code_for_country_name{ "Marshall_Islands" } = "mh" ;
$country_code_for_country_name{ "Mauritania" } = "mr" ;
$country_code_for_country_name{ "Mauritius" } = "mu" ;
$country_code_for_country_name{ "Mexico" } = "mx" ;
$country_code_for_country_name{ "Moldova" } = "md" ;
$country_code_for_country_name{ "Mongolia" } = "mn" ;
$country_code_for_country_name{ "Montenegro" } = "me" ;
$country_code_for_country_name{ "Morocco" } = "ma" ;
$country_code_for_country_name{ "Mozambique" } = "mz" ;
$country_code_for_country_name{ "Myanmar" } = "mm" ;
$country_code_for_country_name{ "Namibia" } = "na" ;
$country_code_for_country_name{ "Nepal" } = "np" ;
$country_code_for_country_name{ "New_Zealand" } = "nz" ;
$country_code_for_country_name{ "Nicaragua" } = "ni" ;
$country_code_for_country_name{ "Nigeria" } = "ng" ;
$country_code_for_country_name{ "Niger" } = "ne" ;
$country_code_for_country_name{ "North_Korea" } = "kp" ;
$country_code_for_country_name{ "Norway" } = "no" ;
$country_code_for_country_name{ "Oman" } = "om" ;
$country_code_for_country_name{ "Pakistan" } = "pk" ;
$country_code_for_country_name{ "Panama" } = "pa" ;
$country_code_for_country_name{ "Papua_New_Guinea" } = "pg" ;
$country_code_for_country_name{ "Paraguay" } = "py" ;
$country_code_for_country_name{ "Peru" } = "pe" ;
$country_code_for_country_name{ "Philippines" } = "ph" ;
$country_code_for_country_name{ "Poland" } = "pl" ;
$country_code_for_country_name{ "Portugal" } = "pt" ;
$country_code_for_country_name{ "Puerto_Rico" } = "pr" ;
$country_code_for_country_name{ "Qatar" } = "qa" ;
$country_code_for_country_name{ "Republic_of_Korea" } = "kr" ;
$country_code_for_country_name{ "Russia" } = "ru" ;
$country_code_for_country_name{ "Rwanda" } = "rw" ;
$country_code_for_country_name{ "Saint_Helena,_Ascension_and_Tristan_da_Cunha" } = "sh" ;
$country_code_for_country_name{ "Saint_Kitts_and_Nevis" } = "kn" ;
$country_code_for_country_name{ "Samoa" } = "ws" ;
$country_code_for_country_name{ "Sao_Tome_and_Príncipe" } = "st" ;
$country_code_for_country_name{ "Saudi_Arabia" } = "sa" ;
$country_code_for_country_name{ "Senegal" } = "sn" ;
$country_code_for_country_name{ "Serbia" } = "rs" ;
$country_code_for_country_name{ "Seychelles" } = "sc" ;
$country_code_for_country_name{ "Sierra_Leone" } = "sl" ;
$country_code_for_country_name{ "Slovakia" } = "sk" ;
$country_code_for_country_name{ "Slovenia" } = "si" ;
$country_code_for_country_name{ "Somalia" } = "so" ;
$country_code_for_country_name{ "South_Africa" } = "za" ;
$country_code_for_country_name{ "South_Georgia_and_the_South_Sandwich_Islands" } = "gs" ;
$country_code_for_country_name{ "South_Sudan" } = "ss" ;
$country_code_for_country_name{ "Spain" } = "es" ;
$country_code_for_country_name{ "Sri_Lanka" } = "lk" ;
$country_code_for_country_name{ "Sudan" } = "sd" ;
$country_code_for_country_name{ "Suriname" } = "sr" ;
$country_code_for_country_name{ "Swaziland" } = "sz" ;
$country_code_for_country_name{ "Sweden" } = "se" ;
$country_code_for_country_name{ "Switzerland" } = "ch" ;
$country_code_for_country_name{ "Syria" } = "sy" ;
$country_code_for_country_name{ "Tadjikistan" } = "tj" ;
$country_code_for_country_name{ "Tanzania" } = "tz" ;
$country_code_for_country_name{ "Thailand" } = "th" ;
$country_code_for_country_name{ "The_Netherlands" } = "nl" ;
$country_code_for_country_name{ "Togo" } = "tg" ;
$country_code_for_country_name{ "Trinidad_and_Tobago" } = "tt" ;
$country_code_for_country_name{ "Tunisia" } = "tn" ;
$country_code_for_country_name{ "Turkey" } = "tr" ;
$country_code_for_country_name{ "Turkmenistan" } = "tk" ;
$country_code_for_country_name{ "Turkmenistan" } = "tm" ;
$country_code_for_country_name{ "Uganda" } = "ug" ;
$country_code_for_country_name{ "UK" } = "gb" ;
$country_code_for_country_name{ "Ukraine" } = "ua" ;
$country_code_for_country_name{ "United_Arab_Emirates" } = "ae" ;
$country_code_for_country_name{ "United_States" } = "us" ;
$country_code_for_country_name{ "Uruguay" } = "uy" ;
$country_code_for_country_name{ "USA" } = "gu" ;
$country_code_for_country_name{ "Uzbekistan" } = "uz" ;
$country_code_for_country_name{ "Venezuela" } = "ve" ;
$country_code_for_country_name{ "Vietnam" } = "vn" ;
$country_code_for_country_name{ "Yemen" } = "ye" ;
$country_code_for_country_name{ "Zambia" } = "zm" ;
$country_code_for_country_name{ "Zimbabwe" } = "zw" ;


#--------------------------------------------------
#  Initialization.

$highest_rank = 0 ;


#--------------------------------------------------
#  Create the output files.

open( OUTFILE , ">" . $output_filename_processed_city_info ) ;
open( COUNTRY_FILE , ">" . $output_filename_country_codes ) ;


#--------------------------------------------------
#  Handle special cases.
#  These are inserted at the top ranking level so
#  they will override later info with the same
#  searchable city name.

print OUTFILE "999 portland or us 10455202471 08773258050 n1666626393 Portland" . "\n" ;
print OUTFILE "999 pdx or us 10455202471 08773258050 n1666626393 Portland" . "\n" ;
print OUTFILE "011 portland wi us 10437688581 09091418126 n151458990 Portland" . "\n" ;
print OUTFILE "700 portland ?? nz 09642030343 11743267053 n1956278617 Portland" . "\n" ;
print OUTFILE "500 vancouver bc ca 10492608724 08768860479 r1852574 Vancouver" . "\n" ;
print OUTFILE "500 vancouver_bc bc ca 10492608724 08768860479 r1852574 Vancouver" . "\n" ;
print OUTFILE "999 philly pa us 10399527237 90248464737 n5518033962 Philadelphia" . "\n" ;
print OUTFILE "999 phl pa us 10399527237 90248464737 n5518033962 Philadelphia" . "\n" ;
print OUTFILE "999 sf ca us 10377792768 08775807295 n26819236 San_Francisco" . "\n" ;
print OUTFILE "999 sfo ca us 10377792768 08775807295 n26819236 San_Francisco" . "\n" ;
print OUTFILE "999 la ca us 10340536781 08817572974 n1738808199 Los_Angeles" . "\n" ;
print OUTFILE "999 lax ca us 10340536781 08817572974 n1738808199 Los_Angeles" . "\n" ;
print OUTFILE "999 st._louis mo us 10386272733 09098021110 n151786910 St._Louis" . "\n" ;
print OUTFILE "999 st._louis_mo mo us 10386272733 09098021110 n151786910 St._Louis" . "\n" ;
print OUTFILE "999 saint_louis_mo mo us 10386272733 09098021110 n151786910 St._Louis" . "\n" ;
print OUTFILE "999 stl mo us 10386272733 09098021110 n151786910 St._Louis" . "\n" ;
print OUTFILE "999 ny ny us 10407305991 09260134187 n61785451 New_York" . "\n" ;
print OUTFILE "999 nyc ny us 10407305991 09260134187 n61785451 New_York" . "\n" ;
print OUTFILE "999 dc dc us 10388950368 99229634572 n158368533 Washington_DC" . "\n" ;
print OUTFILE "999 dca dc us 10388950368 99229634572 n158368533 Washington_DC" . "\n" ;
print OUTFILE "999 iad dc us 10388950368 99229634572 n158368533 Washington_DC" . "\n" ;
print OUTFILE "999 washington dc us 10388950368 99229634572 n158368533 Washington_DC" . "\n" ;
print OUTFILE "900 salt_lake_city ut us 10407596198 08881132029 n150935219 Salt_Lake_City" . "\n" ;
print OUTFILE "900 slc ut us 10407596198 08881132029 n150935219 Salt_Lake_City" . "\n" ;


#--------------------------------------------------
#  Read each line in the file.

$line_count = 1 ;
while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    $line_count ++ ;


#--------------------------------------------------
#  Convert a "full stop" into a period, and
#  convert Unicode 58 into ":" (colon) character, and
#  convert Unicode 59 (semicolon) into "__", and
#  convert Unicode 44 (comma) into a comma.

    $input_line =~ s/&#46;/\./g ;
    $input_line =~ s/&#58;/:/g ;
    $input_line =~ s/&#59;/__/g ;
    $input_line =~ s/&#44;/,/g ;


#--------------------------------------------------
#  Get information from the next city-info line.
#
#  Sample input line:
#      10356823815 11397530053 n265018692 &#26481;&#20140;&#37117; no_label name&#58;en_Tokyo lang_count_41 admin_level_2 place_city population_12790000  is_in:country_Japan is_in:country_code_JP is_in:island_Honshu links_
#
#  Skip any single-digit node IDs because "n4"
#  contains bad data.

    $remainder_of_line = $input_line ;
    if ( $remainder_of_line =~ /^([0-9]+)[ _]([0-9]+) +([nwr][0-9][0-9]+) +([^ ]+) +([^ ].+)/ )
    {
        $latitude_integer = $1 ;
        $longitude_integer = $2 ;
        $node_or_way_or_relation_id = $3 ;
        $city_name = $4 ;
        $remainder_of_line = $5 ;
    } else
    {
        next ;
    }


#--------------------------------------------------
#  Do initialization for this city.

# print OUTFILE "\n" . "input_line = " . $input_line . "\n" ;

    %displayed_name_for_lowercase_alternate_name = ( ) ;
    $name_language_count = "" ;
    $admin_level = "" ;
    $population_count = "" ;
    $city_type = "" ;
    $list_of_links = "" ;


#--------------------------------------------------
#  Generate a searchable lowercase version of the
#  name (without diacritical marks).
#  This has no effect on non-latin names.
#  Add this "generic" version to a list of alternate
#  names that can be found when searching.

    $name = $city_name ;
    &generate_searchable_lowercase_name( ) ;
    $non_accented_lowercase_name = $searchable_lowercase_name ;
    $displayed_name_for_lowercase_alternate_name{ $non_accented_lowercase_name } = $city_name ;


#--------------------------------------------------
#  Count how many times this searchable city name
#  occurs.

    $count_of_city_name_searchable{ $non_accented_lowercase_name } ++ ;


#--------------------------------------------------
#  Get alternate names for this city.  They will be
#  used to allow the city to be found using any of
#  these alternate names.

    $alternate_names_string = "" ;
    $remainder_of_line = " " . $remainder_of_line . " " ;
# an endless loop can occur if the next line is edited without also checking the line below
    while ( $remainder_of_line =~ /^(.*) +((alt_name)|(int_name)|(name:[a-z][a-z])|(official_name))_([^ ]+) +(.*)$/ )
    {
# an endless loop can occur if the next line is not correct for the regular expression above
        $remainder_of_line = $1 . " " . $8 ;
        $alternate_names_string .= " " . $7 . " " ;
    }
    $remainder_of_line =~ s/  +/ / ;
    if ( $alternate_names_string =~ /[^ ]/ )
    {
        $original_alternate_names_string = $alternate_names_string ;
        $alternate_names_string = "_" . lc( $alternate_names_string ) . "_" ;
        $alternate_names_string =~ s/[ _]alt_name_/ /g ;
        $alternate_names_string =~ s/[ _]int_name_/ /g ;
        $alternate_names_string =~ s/[ _]name:[a-z][a-z]_/ /g ;
        $alternate_names_string =~ s/[ _]official_name_/ /g ;
        $alternate_names_string =~ s/ +_+/ /g ;
        $alternate_names_string =~ s/_+ +/ /g ;
        $alternate_names_string =~ s/^[_ ]+// ;
        $alternate_names_string =~ s/[_ ]+$// ;
        $alternate_names_string =~ s/__+/ / ;
        $alternate_names_string =~ s/  +/ / ;

#  print $original_alternate_names_string . "\n" . $alternate_names_string . "\n\n" ;

        @list_of_alternate_names_from_split = split( / +/ , $alternate_names_string ) ;
        foreach $alternate_name ( @list_of_alternate_names_from_split )
        {
            $name = $alternate_name ;
            &generate_searchable_lowercase_name( ) ;
            $lowercase_alternate_name = $searchable_lowercase_name ;
            if ( $lowercase_alternate_name =~ /[^ ]/ )
            {
                $displayed_name_for_lowercase_alternate_name{ $lowercase_alternate_name } = $city_name ;
            }
        }
    }


#--------------------------------------------------
#  Extract additional information.

    if ( $remainder_of_line =~ / lang_count_([0-9]+) / )
    {
        $name_language_count = $1 ;
        if ( $name_language_count + 0 > 20 )
        {
            $name_language_count = "20" ;
        }
    }
    if ( $remainder_of_line =~ / admin_level_([0-9]+) / )
    {
        $admin_level = $1 ;
        if ( ( $admin_level + 0 > 20 ) || ( $admin_level + 0 < 0 ) )
        {
            $admin_level = "20" ;
        }
    }
    if ( $remainder_of_line =~ / population_([0-9]+) / )
    {
        $population_count = $1 ;
        if ( ( $population_count + 0 > 20 ) || ( $population_count + 0 < 0 ) )
        {
            $population_count = "20" ;
        }
    }
    if ( $remainder_of_line =~ / (((place)|(boundary))_[^ ]+) / )
    {
        $city_type = $1 ;
    }
    if ( $remainder_of_line =~ / links_([^ ]+) / )
    {
        $list_of_links = $1 ;
    }


#--------------------------------------------------
#  Get country codes and names, and get state and
#  province codes and names.

    $country_code = "" ;
    $country_name = "" ;
    $state_or_province_code = "" ;
    $state_or_province_name = "" ;
# an endless loop can occur if the next line is edited without also checking the line below
    while ( $remainder_of_line =~ /^(.*) +is_in:(((country)|(state)|(province))(_code)?)_([^ ]+) +(.*)$/i )
    {
# an endless loop can occur if the next line is not correct for the regular expression above
        $remainder_of_line = $1 . " " . $9 ;
        $data_type = $2 ;
        $code_or_name = $8 ;
        $data_type = lc( $data_type ) ;
        if ( $data_type eq "country_code" )
        {
            if ( $code_or_name =~ /^[a-z][a-z]$/i )
            {
                $country_code = lc( $code_or_name ) ;
            }
        }
        if ( ( $data_type eq "state_code" ) || ( $data_type eq "province_code" ) )
        {
            if ( $code_or_name =~ /^[a-z][a-z]$/i )
            {
                $state_or_province_code = lc( $code_or_name ) ;
            }
        }
        if ( $data_type eq "country" )
        {
            if ( ( $code_or_name !~ /;/ ) || ( $code_or_name =~ /&#[0-9]+;/ ) )
            {
                $country_name = $code_or_name ;
            }
        }
        if ( ( $data_type eq "state" ) || ( $data_type eq "province" ) )
        {
            if ( ( $code_or_name !~ /;/ ) || ( $code_or_name =~ /&#[0-9]+;/ ) )
            {
                $state_or_province_name = $code_or_name ;
            }
        }
    }


#--------------------------------------------------
#  If both the country code and the country name
#  are specified in the same entity, contribute to
#  the lookup tables that link those items.

    if ( ( $country_code ne "" ) && ( $country_name ne "" ) )
    {
        if ( exists( $country_name_for_country_code{ $country_code } ) )
        {
            if ( $country_name_for_country_code{ $country_code } ne $country_name )
            {
#                print "Warning: Different country names for country code " . $country_code . " are: " . $country_name_for_country_code{ $country_code } . "  &  " . $country_name . "\n" ;
            }
        } else
        {
            $country_name_for_country_code{ $country_code } = $country_name ;
            $country_code_for_country_name{ $country_name } = $country_code ;
        }
    }


#--------------------------------------------------
#  If the country name is known, but the country code
#  is not supplied here, get the country code.

    if ( ( $country_code eq "" ) && ( $country_name ne "" ) && ( exists( $country_code_for_country_name{ $country_name } ) ) )
    {
        $country_code = $country_code_for_country_name{ $country_name } ;
    }


#--------------------------------------------------
#  If both the state/province code and the
#  state/province name are specified in the same
#  entity, and if the country code is
#  US or CA or CH or RU (each of which is actually
#  a group of "countries")
#  then contribute to the lookup tables that link
#  those items.

    if ( ( $state_or_province_code ne "" ) && ( $state_or_province_name ne "" ) && ( ( $country_code eq "us" ) || ( $country_code eq "ca" ) || ( $country_code eq "ch" ) || ( $country_code eq "ru" ) ) )
    {
        if ( exists( $country_code_and_state_or_province_code_for_country_code_and_state_or_province_name{ $country_code . "_" . $state_or_province_name } ) )
        {
            $do_nothing ++ ;
        } else
        {
            $state_or_province_code_for_country_code_and_state_or_province_name{ $country_code . "_" . $state_or_province_name } = $state_or_province_code ;
        }
        $yes_if_state_or_province_code_known = "yes" ;
    }


#--------------------------------------------------
#  If the country code and state/province name are
#  known, but the state/province code is not supplied
#  here, get the state/province code.

    if ( ( $country_code ne "" ) && ( $country_name ne "" ) && ( exists( $state_or_province_code_for_country_code_and_state_or_province_name{ $country_code . "_" . $state_or_province_name } ) ) )
    {
        $state_or_province_code = $state_or_province_code_for_country_code_and_state_or_province_name{ $country_code . "_" . $state_or_province_name } ;
    }


#--------------------------------------------------
#  Determine the corner points for each country.

    if ( $country_code ne "" )
    {
        if ( exists( $maximum_latitude_for_country_code{ $country_code } ) )
        {
            if ( $latitude_integer > $maximum_latitude_for_country_code{ $country_code } )
            {
                $maximum_latitude_for_country_code{ $country_code } = $latitude_integer ;
            }
        } else
        {
            $maximum_latitude_for_country_code{ $country_code } = $latitude_integer ;
        }
        if ( exists( $minimum_latitude_for_country_code{ $country_code } ) )
        {
            if ( $latitude_integer < $minimum_latitude_for_country_code{ $country_code } )
            {
                $minimum_latitude_for_country_code{ $country_code } = $latitude_integer ;
            }
        } else
        {
            $minimum_latitude_for_country_code{ $country_code } = $latitude_integer ;
        }
        if ( exists( $maximum_longitude_for_country_code{ $country_code } ) )
        {
            if ( $longitude_integer > $maximum_longitude_for_country_code{ $country_code } )
            {
                $maximum_longitude_for_country_code{ $country_code } = $longitude_integer ;
            }
        } else
        {
            $maximum_longitude_for_country_code{ $country_code } = $longitude_integer ;
        }
        if ( exists( $minimum_longitude_for_country_code{ $country_code } ) )
        {
            if ( $longitude_integer < $minimum_longitude_for_country_code{ $country_code } )
            {
                $minimum_longitude_for_country_code{ $country_code } = $longitude_integer ;
            }
        } else
        {
            $minimum_longitude_for_country_code{ $country_code } = $longitude_integer ;
        }
    }


#--------------------------------------------------
#  Use question marks if the country code or
#  state/province code is unknown.

    if ( $country_code eq "" )
    {
        $country_code = "??" ;
    }
    if ( $state_or_province_code eq "" )
    {
        $state_or_province_code = "??" ;
    }


#--------------------------------------------------
#  Ignore cities without a name, and ignore a
#  city or neighborhood with a one-letter "name".

    if ( ( $city_name eq "name_unknown" ) || ( $city_name =~ /^[a-z]$/i ) )
    {
        next ;
    }


#--------------------------------------------------
#  Note:
#  If this data is a duplicate (the name and location
#  are the same) that is OK, because only the
#  first version will be used.


#--------------------------------------------------
#  Calculate a ranking level that is used during
#  sorting.  Cities rank higher if they are large
#  and important.
#  This ensures that "paris" will match
#  Paris France, not Paris Texas.
#  Nodes do not contain an "admin level" -- if the
#  OSM recommendations have been followed -- so
#  they are automatically further reduced in rank.
#
#  Nodes n26819236 and n1336151032 are
#  San Fransisco CA.  The ranking
#  algorithm does not work for this city, so node
#  n26819236 is explicitly ranked above smaller
#  cities with the same name.

    $rank = 0 ;
    if ( $admin_level ne "" )
    {
        $rank = 1  + $name_language_count + ( 3 * ( length( $population_count ) + ( 10 - $admin_level ) ) ) ;
    } else
    {
        $rank = 1  + $name_language_count + ( 3 * ( length( $population_count ) ) ) ;
    }
    if ( exists( $rank_score_for_city_type{ $city_type } ) )
    {
        $rank = $rank + $rank_score_for_city_type{ $city_type } ;
    }
    if ( $rank > $highest_rank )
    {
        $highest_rank = $rank ;
#        print "highest rank: " . $highest_rank . "\n" ;
    }
    if ( $rank > 999 )
    {
        $rank = 999 ;
    } elsif ( $rank < 1 )
    {
        $rank = 1 ;
    }
    if ( $node_or_way_or_relation_id eq "n26819236" )
    {
        $rank = 999 ;
    }
    if ( $node_or_way_or_relation_id eq "n1336151032" )
    {
        $rank = 998 ;
    }
    $rank_as_text = sprintf( "%03d" , $rank ) ;
    $count_of_items_at_rank_number{ $rank_as_text } ++ ;


#--------------------------------------------------
#  If the last word in a city name is "city",
#  or the name begins with "city of", then create
#  the simplified version as an alternate name
#  for search purposes.
#  For example, "Mexico City" can be found using
#  "Mexico".

    if ( $non_accented_lowercase_name =~ / [Cc]ity *$/ )
    {
        $alternate_name = $non_accented_lowercase_name ;
        $alternate_name =~ s/ [Cc]ity *$// ;
        $displayed_name_for_lowercase_alternate_name{ $alternate_name } = $city_name ;
    } elsif ( $non_accented_lowercase_name =~ /^ *[Cc]ity of / )
    {
        $alternate_name = $non_accented_lowercase_name ;
        $alternate_name =~ s/^ *[Cc]ity of // ;
        $displayed_name_for_lowercase_alternate_name{ $alternate_name } = $city_name ;
        $alternate_name = $alternate_name . "_city" ;
        $displayed_name_for_lowercase_alternate_name{ $alternate_name . "_city" } = $city_name ;
    }


#--------------------------------------------------
#  For each city name (for the same city), write
#  the city info.
#  If the nation is US or CA, and the state/province
#  is known, also insert an entry to allow the state/province
#  abbreviation to be part of the city name -- to allow
#  finding Vancouver WA instead of Vancouver BC.
#  If the city name is just question marks or
#  numbers with a single letter, ignore it.

    foreach $lowercase_alternate_name ( keys( %displayed_name_for_lowercase_alternate_name ) )
    {
        $displayed_name = $displayed_name_for_lowercase_alternate_name{ $lowercase_alternate_name } ;
        if ( ( $displayed_name =~ /^[\?]+$/ ) || ( $displayed_name =~ /^[0-9\-]*[a-zA-Z]?[0-9\-]*$/ ) || ( $lowercase_alternate_name =~ /^[\?]+$/ ) || ( $lowercase_alternate_name =~ /^[0-9\-]*[a-zA-Z]?[0-9\-]*$/ ) )
        {
        	next ;
        }
        $uppercase_state_or_province_code = uc( $state_or_province_code ) ;
        $uppercase_country_code = uc( $country_code ) ;
        $info_combined = $uppercase_state_or_province_code . " " . $uppercase_country_code . " " . $latitude_integer . " " . $longitude_integer . " " . $node_or_way_or_relation_id . " " . $displayed_name ;
        print OUTFILE $rank_as_text . " " . $lowercase_alternate_name . " " . $info_combined . "\n" ;
        if ( ( ( $country_code eq "us" ) || ( $country_code eq "ca" ) ) && ( $state_or_province_code ne "??" ) )
        {
            print OUTFILE $rank_as_text . " " . $lowercase_alternate_name . "_" . $state_or_province_code . " " . $info_combined . "\n" ;
        }
    }


#--------------------------------------------------
#  Repeat the loop for the next line in the file.

}


#--------------------------------------------------
#  Write to a file a list of searchable city names
#  that occur more than once.

open( OUTDUPS , ">" . $output_filename_duplicate_city_names ) ;
foreach $non_accented_lowercase_name ( keys( %count_of_city_name_searchable ) )
{
    $city_name_count = $count_of_city_name_searchable{ $non_accented_lowercase_name } ;
    if ( $city_name_count > 1 )
    {
        $duplicate_city_names_at_count{ sprintf( "%03d" , $city_name_count ) } .= $non_accented_lowercase_name . "  " . $city_name_count . "\n" ;
    }
}
foreach $city_name_count ( reverse( sort( keys( %duplicate_city_names_at_count ) ) ) )
{
    print OUTDUPS $duplicate_city_names_at_count{ $city_name_count } ;
}


#--------------------------------------------------
#  Write the list of country codes and their names.
#  Also calculate the geographic middle.

foreach $country_code ( keys( %country_name_for_country_code ) )
{
    $country_name = $country_name_for_country_code{ $country_code } ;
    $center_info = "" ;
    if ( ( exists( $maximum_latitude_for_country_code{ $country_code } ) ) || ( exists( $minimum_latitude_for_country_code{ $country_code } ) ) || ( exists( $maximum_longitude_for_country_code{ $country_code } ) ) || ( exists( $minimum_longitude_for_country_code{ $country_code } ) ) )
    {
        $center_latitude_integer = int( ( $maximum_latitude_for_country_code{ $country_code } +$minimum_latitude_for_country_code{ $country_code } ) / 2 ) ;
        $center_longitude_integer = int( ( $maximum_longitude_for_country_code{ $country_code } +$minimum_longitude_for_country_code{ $country_code } ) / 2 ) ;
        if ( $center_info ne "" )
        {
            $center_info .= " " ;
        }
        $center_info .= sprintf( "%010d" , $center_latitude_integer ) . " " . sprintf( "%010d" , $center_longitude_integer ) ;
    }
    $country_codes_names_centers .= $country_code . " " . $country_name . " " . $center_info . "\n" ;
    $perl_lookup_code_for_country_codes .= '$country_code_for_country_name{ "' . $country_name . '" } = "' . $country_code . '" ;' . "\n" ;
}
print COUNTRY_FILE $perl_lookup_code_for_country_codes . "\n" ;
print COUNTRY_FILE "\n\n\n" ;
print COUNTRY_FILE $country_codes_names_centers . "\n" ;


#--------------------------------------------------
#  Close the output files.

close( OUTFILE ) ;
close( COUNTRY_FILE ) ;



#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#
#  THE NEXT TWO SUBROUTINES ARE ALSO USED IN THE
#  SCRIPTS NAMED
#  osm_consolidate_street_info_by_region.pl
#  osm_get_street_words.pl
#  SO KEEP ALL VERSIONS THE SAME!
#
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#  Subroutine that specifies a non-accented lowercase
#  character for each kind of accented character.

sub initialize_lowercase_equivalent_characters
{

    $lowercase_non_accented_for_character_number{ 138 } = "s" ;  # Š
    $lowercase_non_accented_for_character_number{ 140 } = "c" ;  # Œ
    $lowercase_non_accented_for_character_number{ 142 } = "z" ;  # Ž
    $lowercase_non_accented_for_character_number{ 145 } = "'" ;  # ‘
    $lowercase_non_accented_for_character_number{ 146 } = "'" ;  # ’
    $lowercase_non_accented_for_character_number{ 147 } = '"' ;  # “
    $lowercase_non_accented_for_character_number{ 148 } = '"' ;  # ”
    $lowercase_non_accented_for_character_number{ 150 } = "-" ;  # –
    $lowercase_non_accented_for_character_number{ 151 } = "-" ;  # —
    $lowercase_non_accented_for_character_number{ 152 } = "-" ;  # ˜
    $lowercase_non_accented_for_character_number{ 154 } = "s" ;  # š
    $lowercase_non_accented_for_character_number{ 156 } = "o" ;  # œ
    $lowercase_non_accented_for_character_number{ 158 } = "z" ;  # ž
    $lowercase_non_accented_for_character_number{ 159 } = "y" ;  # Ÿ
    $lowercase_non_accented_for_character_number{ 161 } = "i" ;  # ¡
    $lowercase_non_accented_for_character_number{ 162 } = "c" ;  # ¢
    $lowercase_non_accented_for_character_number{ 167 } = "s" ;  # §
    $lowercase_non_accented_for_character_number{ 173 } = "-" ;  # ­
    $lowercase_non_accented_for_character_number{ 175 } = "-" ;  # ¯
    $lowercase_non_accented_for_character_number{ 176 } = "o" ;  # °
    $lowercase_non_accented_for_character_number{ 180 } = "'" ;  # ´
    $lowercase_non_accented_for_character_number{ 181 } = "u" ;  # µ
    $lowercase_non_accented_for_character_number{ 183 } = "." ;  # ·
    $lowercase_non_accented_for_character_number{ 184 } = "," ;  # ¸
    $lowercase_non_accented_for_character_number{ 186 } = "o" ;  # º
    $lowercase_non_accented_for_character_number{ 192 } = "a" ;  # À
    $lowercase_non_accented_for_character_number{ 193 } = "a" ;  # Á
    $lowercase_non_accented_for_character_number{ 194 } = "a" ;  # Â
    $lowercase_non_accented_for_character_number{ 195 } = "a" ;  # Ã
    $lowercase_non_accented_for_character_number{ 196 } = "a" ;  # Ä
    $lowercase_non_accented_for_character_number{ 197 } = "a" ;  # Å
    $lowercase_non_accented_for_character_number{ 198 } = "a" ;  # Æ
    $lowercase_non_accented_for_character_number{ 199 } = "c" ;  # Ç
    $lowercase_non_accented_for_character_number{ 200 } = "e" ;  # È
    $lowercase_non_accented_for_character_number{ 201 } = "e" ;  # É
    $lowercase_non_accented_for_character_number{ 202 } = "e" ;  # Ê
    $lowercase_non_accented_for_character_number{ 203 } = "e" ;  # Ë
    $lowercase_non_accented_for_character_number{ 204 } = "i" ;  # Ì
    $lowercase_non_accented_for_character_number{ 205 } = "i" ;  # Í
    $lowercase_non_accented_for_character_number{ 206 } = "i" ;  # Î
    $lowercase_non_accented_for_character_number{ 207 } = "i" ;  # Ï
    $lowercase_non_accented_for_character_number{ 208 } = "d" ;  # Ð
    $lowercase_non_accented_for_character_number{ 209 } = "n" ;  # Ñ
    $lowercase_non_accented_for_character_number{ 210 } = "o" ;  # Ò
    $lowercase_non_accented_for_character_number{ 211 } = "o" ;  # Ó
    $lowercase_non_accented_for_character_number{ 212 } = "o" ;  # Ô
    $lowercase_non_accented_for_character_number{ 213 } = "o" ;  # Õ
    $lowercase_non_accented_for_character_number{ 214 } = "o" ;  # Ö
    $lowercase_non_accented_for_character_number{ 215 } = "x" ;  # ×
    $lowercase_non_accented_for_character_number{ 216 } = "o" ;  # Ø
    $lowercase_non_accented_for_character_number{ 217 } = "u" ;  # Ù
    $lowercase_non_accented_for_character_number{ 218 } = "u" ;  # Ú
    $lowercase_non_accented_for_character_number{ 219 } = "u" ;  # Û
    $lowercase_non_accented_for_character_number{ 220 } = "u" ;  # Ü
    $lowercase_non_accented_for_character_number{ 221 } = "y" ;  # Ý
    $lowercase_non_accented_for_character_number{ 222 } = "t" ;  # Þ
    $lowercase_non_accented_for_character_number{ 223 } = "s" ;  # ß
    $lowercase_non_accented_for_character_number{ 224 } = "a" ;  # à
    $lowercase_non_accented_for_character_number{ 225 } = "a" ;  # á
    $lowercase_non_accented_for_character_number{ 226 } = "a" ;  # â
    $lowercase_non_accented_for_character_number{ 227 } = "a" ;  # ã
    $lowercase_non_accented_for_character_number{ 228 } = "a" ;  # ä
    $lowercase_non_accented_for_character_number{ 229 } = "a" ;  # å
    $lowercase_non_accented_for_character_number{ 230 } = "a" ;  # æ
    $lowercase_non_accented_for_character_number{ 231 } = "c" ;  # ç
    $lowercase_non_accented_for_character_number{ 232 } = "e" ;  # è
    $lowercase_non_accented_for_character_number{ 233 } = "e" ;  # é
    $lowercase_non_accented_for_character_number{ 234 } = "e" ;  # ê
    $lowercase_non_accented_for_character_number{ 235 } = "e" ;  # ë
    $lowercase_non_accented_for_character_number{ 236 } = "i" ;  # ì
    $lowercase_non_accented_for_character_number{ 237 } = "i" ;  # í
    $lowercase_non_accented_for_character_number{ 238 } = "i" ;  # î
    $lowercase_non_accented_for_character_number{ 239 } = "i" ;  # ï
    $lowercase_non_accented_for_character_number{ 240 } = "o" ;  # ð
    $lowercase_non_accented_for_character_number{ 241 } = "n" ;  # ñ
    $lowercase_non_accented_for_character_number{ 242 } = "o" ;  # ò
    $lowercase_non_accented_for_character_number{ 243 } = "o" ;  # ó
    $lowercase_non_accented_for_character_number{ 244 } = "o" ;  # ô
    $lowercase_non_accented_for_character_number{ 245 } = "o" ;  # õ
    $lowercase_non_accented_for_character_number{ 246 } = "o" ;  # ö
    $lowercase_non_accented_for_character_number{ 248 } = "o" ;  # ø
    $lowercase_non_accented_for_character_number{ 249 } = "u" ;  # ù
    $lowercase_non_accented_for_character_number{ 250 } = "u" ;  # ú
    $lowercase_non_accented_for_character_number{ 251 } = "u" ;  # û
    $lowercase_non_accented_for_character_number{ 252 } = "u" ;  # ü
    $lowercase_non_accented_for_character_number{ 253 } = "y" ;  # ý
    $lowercase_non_accented_for_character_number{ 254 } = "b" ;  # þ
    $lowercase_non_accented_for_character_number{ 255 } = "y" ;  # ÿ

#    $lowercase_non_accented_for_character_number{ 269 } = "c" ;  # latin small letter c with caron
#    $lowercase_non_accented_for_character_number{ 352 } = "s" ;  # latin capital letter s with caron
#   ... yet more ...
#   ignored,
#   instead, rely on alternate English spelling being supplied.


#--------------------------------------------------
#  End of subroutine.

    return ;

}



#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#  Subroutine to generate a version of the name that
#  replaces any accented symbol with the non-accented
#  lowercase(!) version.  This enables various
#  versions -- in terms of capitalization and
#  the use or non-use of accents -- to be found.

sub generate_searchable_lowercase_name
{


#--------------------------------------------------
#  If needed, initialize the non-accented equivalent
#  characters.

    if ( not( exists( $lowercase_non_accented_for_character_number{ 255 } ) ) )
    {
        &initialize_lowercase_equivalent_characters( ) ;
    }


#--------------------------------------------------
#  Generate a version of the name that replaces
#  any accented symbol with the non-accented
#  lowercase(!) version.
#
#  Convert a "full stop" -- Unicode 46 -- into a period, and
#  convert Unicode 58 into ":" (colon) character, and
#  convert Unicode 59 (semicolon) into ";", and
#  convert Unicode 44 (comma) into a comma.

    $possibly_accented_name = $name ;
    $possibly_accented_name =~ s/&#46;/\./g ;
    $possibly_accented_name =~ s/&#58;/:/g ;
    $possibly_accented_name =~ s/&#59;/;/g ;
    $possibly_accented_name =~ s/&#44;/,/g ;
    $remainder_of_possibly_accented_name = lc( $possibly_accented_name ) ;
    $searchable_lowercase_name = "" ;
    while ( $remainder_of_possibly_accented_name =~ /^(.*?)\&#([0-9]+);(.*)$/ )
    {
        $prefix_string = $1 ;
        $unicode_number_as_text = $2 ;
        $remainder_of_possibly_accented_name = $3 ;
        $unicode_number = $unicode_number_as_text + 0 ;
        if ( exists( $lowercase_non_accented_for_character_number{ $unicode_number } ) )
        {
            $character_non_accented_lowercase = $lowercase_non_accented_for_character_number{ $unicode_number } ;
        } elsif ( ( ( $unicode_number > 687 ) && ( $unicode_number < 768 ) ) || ( ( $unicode_number > 7467 ) && ( $unicode_number < 7616 ) ) || ( ( $unicode_number > 42751 ) && ( $unicode_number < 42775 ) ) )
        {
#  ignore "combining diacritical marks" which are from U+0300 to U+036F, and ignore other "modifiers"
            $do_nothing ++ ;
        } else
        {
            $character_non_accented_lowercase = '&#' . $unicode_number_as_text . ';' ;
        }
        $searchable_lowercase_name .= $prefix_string . $character_non_accented_lowercase ;
    }
    $searchable_lowercase_name .= $remainder_of_possibly_accented_name ;


#--------------------------------------------------
#  End of subroutine.

    return ;

}
