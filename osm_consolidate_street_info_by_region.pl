#--------------------------------------------------
#       osm_consolidate_street_info_by_region.pl
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


#--------------------------------------------------
#  Usage:
#  Edit this script for input and output paths,
#  then in terminal run:
#  perl osm_consolidate_street_info_by_region.pl
#  Do not specify output log file so that progress is
#  monitored in the terminal window.


#--------------------------------------------------
#  Specify the INPUT filename prefixes.
#  If there are any changes here, also possibly
#  change the regular expression below.

# $directory_intersections_by_region = "/home/aw/FilesNoArchive/OpenStreetMapData/intersections_by_region/" ;
$directory_intersections_by_region = "./output_files/intersections_by_region/" ;

$file_name_prefix_for_intersections = $directory_intersections_by_region . "output_intersections_in_region_" ;

# $file_name_prefix_for_street_names = "/home/aw/FilesNoArchive/OpenStreetMapData/street_names_by_region/output_street_names_in_region_" ;
$file_name_prefix_for_street_names = "./output_files/street_names_by_region/output_street_names_in_region_" ;


#--------------------------------------------------
#  Specify the OUTPUT filenames.

# $file_name_for_all_intersections = "/home/aw/FilesNoArchive/OpenStreetMapData/output_intersections_all_regions.txt" ;
$file_name_for_all_intersections = "./output_files/output_intersections_all_regions.txt" ;

# $file_name_for_all_street_names = "/home/aw/FilesNoArchive/OpenStreetMapData/output_street_names_all_regions.txt" ;
$file_name_for_all_street_names = "./output_files/output_street_names_all_regions.txt" ;

# $file_name_for_all_street_words = "/home/aw/FilesNoArchive/OpenStreetMapData/output_street_words_all_regions.txt" ;
$file_name_for_all_street_words = "./output_files/output_street_words_all_regions.txt" ;


#--------------------------------------------------
#  Initialization.

&initialize_lowercase_equivalent_characters( ) ;

$altered_digit_for_digit{ "0" } = 1 ;
$altered_digit_for_digit{ "1" } = 2 ;
$altered_digit_for_digit{ "2" } = 3 ;
$altered_digit_for_digit{ "3" } = 4 ;
$altered_digit_for_digit{ "4" } = 5 ;
$altered_digit_for_digit{ "5" } = 4 ;
$altered_digit_for_digit{ "6" } = 5 ;
$altered_digit_for_digit{ "7" } = 6 ;
$altered_digit_for_digit{ "8" } = 7 ;
$altered_digit_for_digit{ "9" } = 8 ;


#---------------------------------------------------
#  Create the list of regions that need to be
#  handled.
#  If there are any changes in the filename here,
#  also change the related assignments above.
#
#  Just use the categories based on the street nodes,
#  which allows testing with a subset of street nodes.

if ( opendir( READ_DIR , $directory_intersections_by_region ) )
{
    while ( defined( $file_name = readdir( READ_DIR ) ) )
    {
        if ( $file_name =~ /^output_intersections_in_region_([^ ]+)\.txt$/i )
        {
            $region = $1 ;
            $list_of_regions{ $region } = "y" ;
        }
    }
    closedir( READ_DIR ) ;
}


#  if needed for testing:
# %list_of_regions = ( ) ;
# $list_of_regions{ "1044_0877" } = "y" ;
# $list_of_regions{ "1045_0877" } = "y" ;


@sorted_list_of_regions = sort( keys( %list_of_regions ) ) ;
$region_count = $#sorted_list_of_regions + 1 ;
print "There are " . $region_count . " regions" . "\n" ;


#--------------------------------------------------
#  Open the output files.

open OUT_INTERSECTIONS , ">" . $file_name_for_all_intersections ;
open OUT_STREET_NAMES , ">" . $file_name_for_all_street_names ;
open OUT_STREET_WORDS , ">" . $file_name_for_all_street_words ;


#--------------------------------------------------
#  Begin a loop that handles each region.

foreach $region ( @sorted_list_of_regions )
{
    $region_within_filename = $region ;


#--------------------------------------------------
#  Show progress.

    print "region " . $region . "\n" ;


#--------------------------------------------------
#  Clear the lists used for the prior region.

    %have_info_for_way_ids = ( ) ;
    %have_info_for_way_id = ( ) ;
    %street_name_for_way_id = ( ) ;
    %list_of_way_ids_for_street_word = ( ) ;
    %list_of_street_words = ( ) ;


#--------------------------------------------------
#  Start handling each line of intersection info.

    open( IN_INTERSECTIONS , "<" . $file_name_prefix_for_intersections . $region_within_filename . '.txt' ) ;
    while( $input_line = <IN_INTERSECTIONS> )
    {
        chomp( $input_line ) ;
        if ( $input_line =~ /^(w[0-9]+ w[0-9]+) ([^ ].+)/ )
        {
            $way_ids = $1 ;
            $lat_lon_remainders = $2 ;
            if ( not( exists( $have_info_for_way_ids{ $way_ids } ) ) )
            {
                $have_info_for_way_ids{ $way_ids } = "y" ;


#--------------------------------------------------
#  Finish handling each line of intersection info.
#  Modify the last digit of the longitude for way
#  IDs that contain the digits 61525 to "watermark"
#  this data as having been generated by this code.
#  The numbers 6, 15, 2, 5 are the positions of
#  the letters F, O, B, E within the alphabet.

                if ( index( $way_ids , "61525" ) > -1 )
                {
                    $lat_lon_remainders = substr( $lat_lon_remainders , 0 , 14 ) . $altered_digit_for_digit{ substr( $lat_lon_remainders , -1 , 1 ) } ;
                }
                print OUT_INTERSECTIONS $region . " " . $way_ids . " " . $lat_lon_remainders . "\n" ;
            }
        }
    }
    close( IN_INTERSECTIONS ) ;


#--------------------------------------------------
#  Begin handling each line of street name info.

    open( IN_STREETS , "<" . $file_name_prefix_for_street_names . $region_within_filename . '.txt' ) ;
    while( $input_line = <IN_STREETS> )
    {
        chomp( $input_line ) ;
        if ( $input_line =~ /^(w[0-9]+) ([^ ]+)/ )
        {
            $way_id = $1 ;
            $street_name = $2 ;
            $street_name =~ s/&#46;/\./g ;
            if ( not( exists( $have_info_for_way_id{ $way_id } ) ) )
            {
                $category = 'pattern_' . substr( $way_id , -2 , 2 ) . '/' . substr( ( "000" . $way_id ) , -4 , 2 ) ;
                print OUT_STREET_NAMES $category . " " . $way_id . " " . $street_name . "\n" ;
                $have_info_for_way_id{ $way_id } = "y" ;


#--------------------------------------------------
#  Identify the searchable lowercase versions of
#  the street words that appear in this street name.
#
#  Besides splitting each street name at the
#  spaces (which are indicated by underscores),
#  also split at apostrophes.
#  The searchable street name does not have an
#  apostrophe before an "s" (as in Denny's)
#  because those apostrophes were removed.
#
#  If the street name contains only HTML
#  entities, and the first Unicode number refers
#  to a Chinese or Korean or similar ideograph
#  character, then split at every character.
#  Does not support Thai language because a
#  space between words is not required.
#  Note that "pinyin" text is phonetic, so it
#  does include spaces.
#  Create a searchable lowercase version of the
#  word for searching purposes.

                $name = $street_name ;
                &generate_searchable_lowercase_name( ) ;
                $modified_street_name = $searchable_lowercase_name ;
                $modified_street_name =~ s/&#39;/_/g ;
                if ( ( $modified_street_name !~ /_/ ) && ( $modified_street_name =~ /^(&#[0-9]+;)+$/ ) )
                {
                    if ( $modified_street_name =~ /^&#([0-9]+);/ )
                    {
                        $unicode_number = $1 ;
                        if ( ( ( $unicode_number >= 0xF0000 ) && ( $unicode_number <= 0xFFFFF ) ) || ( ( $unicode_number >= 0x100000 ) && ( $unicode_number <= 0x10FFFF ) ) || ( ( $unicode_number >= 0x20000 ) && ( $unicode_number <= 0x2A6DF ) ) || ( ( $unicode_number >= 0x4E00 ) && ( $unicode_number <= 0x9FFF ) ) || ( ( $unicode_number >= 0x3400 ) && ( $unicode_number <= 0x4DBF ) ) || ( ( $unicode_number >= 0x2A700 ) && ( $unicode_number <= 0x2B73F ) ) || ( ( $unicode_number >= 0x2F800 ) && ( $unicode_number <= 0x2FA1F ) ) || ( ( $unicode_number >= 0xF900 ) && ( $unicode_number <= 0xFAFF ) ) || ( ( $unicode_number >= 0x3300 ) && ( $unicode_number <= 0x33FF ) ) || ( ( $unicode_number >= 0x2B740 ) && ( $unicode_number <= 0x2B81F ) ) )
                        {
                            $modified_street_name =~ s/;&#/;_&#/g ;
                        }
                    }
                }
                @list_of_street_words = split( /_+/ , $modified_street_name ) ;


#--------------------------------------------------
#  Add the current way ID to the list of way IDs
#  for the associated street words.

                foreach $street_word ( @list_of_street_words )
                {
                    if ( not( exists( $ignore_street_word{ $street_word } ) ) )
                    {
                        $list_of_way_ids_for_street_word{ $street_word } .= $way_id . " " ;
                    }
                }


#--------------------------------------------------
#  Finish handling each line of street name info.

            }
        }
    }
    close( IN_STREETS ) ;


#--------------------------------------------------
#  Write the street words for this region.

    foreach $street_word ( keys( %list_of_way_ids_for_street_word ) )
    {
        $list_of_way_ids = $list_of_way_ids_for_street_word{ $street_word } ;
        $list_of_way_ids =~ s/ +$// ;
        print OUT_STREET_WORDS $region . " " . $street_word . " " . $list_of_way_ids . "\n" ;
    }


#--------------------------------------------------
#  Repeat the loop that handles each region.

}


#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#
#  THE NEXT TWO SUBROUTINES ARE ALSO USED IN THE
#  SCRIPTS NAMED
#  osm_handle_city_info.pl
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
