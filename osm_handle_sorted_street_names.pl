#--------------------------------------------------
#       osm_handle_sorted_street_names.pl
#--------------------------------------------------

#  (c) Copyright 2022-2023 by Richard Fobes at SolutionsCreative.com
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
#
#  perl osm_handle_sorted_street_names.pl

#--------------------------------------------------


#--------------------------------------------------
#  Sample input lines:

#  w276849 2 Strathmore_Gardens
#  w276849 4 1051_0999
#  w276850 2 Oakfield_Road
#  w276850 4 1051_0999
#  w276851 2 Dukes_Avenue
#  w276851 4 1051_0999


#--------------------------------------------------
#  Sample output lines:

# 1052_0998 maney w37
# 1052_0998 hill w37
# 1052_0998 road w37
# 1052_0998 douglas w45
# 1052_0998 road w45
# 1052_0998 shipton w46


#--------------------------------------------------
#  Initialization:

$yes_yes = 1 ;
$no_no = 0 ;
$yes_valid_line_type{ "1" } = $yes_yes ;
$yes_valid_line_type{ "2" } = $yes_yes ;
$yes_valid_line_type{ "3" } = $yes_yes ;
$yes_valid_line_type{ "4" } = $yes_yes ;


#--------------------------------------------------
#  Currently the code in this section is not active.
#
#  Important:  These adjustments reduce some areas
#  of the globe/Earth to use only older way IDs.
#  This limits the number of intersections in areas
#  such as Asia and India where fewer users are
#  currently located.  Later the full
#  data for the entire globe should be used.
#  When that happens, eliminate this adjustment
#  that reduces server storage requirements.  Do
#  NOT just change these numbers!  Fully eliminate
#  the use of the
#  "yes_need_full_coverage_in_region_id"
#  associative array.
#
#  Specify which regions of the globe need full
#  data coverage.  Include North America,
#  Europe, Japan, South Korea, Australia,
#  New Zealand.  Other regions will get their
#  data truncated to data that already existed
#  when the way ID numbers reached 5,000,000.

#  North America:
$latitude_region_number_begin[ 1 ] = 1000 ;
$latitude_region_number_end[ 1 ] = 1080 ;
$longitude_region_number_begin[ 1 ] = 829 ;
$longitude_region_number_end[ 1 ] = 949 ;

#  Europe, spans zero longitude:
$latitude_region_number_begin[ 2 ] = 1025 ;
$latitude_region_number_end[ 2 ] = 1080 ;
$longitude_region_number_begin[ 2 ] = 974 ;
$longitude_region_number_end[ 2 ] = 1060 ;

#  Japan:
$latitude_region_number_begin[ 3 ] = 1025 ;
$latitude_region_number_end[ 3 ] = 1046 ;
$longitude_region_number_begin[ 3 ] = 1124 ;
$longitude_region_number_end[ 3 ] = 1146 ;

#  Australia and New Zealand:
$latitude_region_number_begin[ 4 ] = 948 ;
$latitude_region_number_end[ 4 ] = 992 ;
$longitude_region_number_begin[ 4 ] = 1111 ;
$longitude_region_number_end[ 4 ] = 1179 ;

#  remove NW area from Japan:
$latitude_region_number_begin[ 5 ] = 1038 ;
$latitude_region_number_end[ 5 ] = 1046 ;
$longitude_region_number_begin[ 5 ] = 1124 ;
$longitude_region_number_end[ 5 ] = 1137 ;

# for ( $which_region = 1 ; $which_region <= 5 ; $which_region ++ )
# {
#     for ( $latitude_region_number = $latitude_region_number_begin[ $which_region ] ; $latitude_region_number <= $latitude_region_number_end[ $which_region ] ; $latitude_region_number ++ )
#     {
#         for ( $longitude_region_number = $longitude_region_number_begin[ $which_region ] ; $longitude_region_number <= $longitude_region_number_end[ $which_region ] ; $longitude_region_number ++ )
#         {
#             $region_id = sprintf( "%04d" , $latitude_region_number ) . "_" . sprintf( "%04d" , $longitude_region_number ) ;
#             if ( $which_region <= 4 )
#             {
#                 $yes_need_full_coverage_in_region_id{ $region_id } = "y" ;
#             } else
#             {
#                 delete( $yes_need_full_coverage_in_region_id{ $region_id } ) ;
#             }
#         }
#     }
# }


#--------------------------------------------------
#  Open the output files.

$output_filename_street_names = "output_sortable_street_names.txt" ;
open( OUT_STREET_NAMES , ">" , $output_filename_street_names ) ;
print "creating output file " . $output_filename_street_names . "\n" ;
$output_filename_street_words = "output_sortable_street_words.txt" ;
open( OUT_STREET_WORDS , ">" , $output_filename_street_words ) ;
print "creating output file " . $output_filename_street_words . "\n" ;
$output_filename_regions_streets = "output_sortable_regions_streets.txt" ;
open( OUT_REGION_STREET , ">" , $output_filename_regions_streets ) ;
print "creating output file " . $output_filename_regions_streets . "\n" ;


#--------------------------------------------------
#  Begin a loop that reads each line of the
#  input file.

$input_filename = 'output_regions_names_sorted_by_street_id.txt' ;
open( IN_FILE , "<" . $input_filename ) ;
while( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;


#--------------------------------------------------
#  Get the information from the line.  If the line
#  is not recognized, repeat the loop.

    if ( $input_line =~ /^([wr])([0-9]+) ([1-9]) ([^ ]+)/ )
    {
        $way_or_relation_type = $1 ;
        $street_id = $2 ;
        $line_type = $3 ;
        $street_name_or_region_id = $4 ;
    } else
    {
        print "unrecognized line: " . $input_line . "\n" ;
        next ;
    }
    if ( $yes_valid_line_type{ $line_type } != $yes_yes )
    {
        print "unrecognized line: " . $input_line . "\n" ;
        next ;
    }


#--------------------------------------------------
#  If the line contains a new street name, save the
#  name, then repeat the loop.

    if ( ( $line_type eq "1" ) || ( $line_type eq "2" ) )
    {
        $street_name = $street_name_or_region_id ;
        $street_name =~ s/&#46;/\./g ;
        $yes_or_no_wrote_current_street_name = $no_no ;
        next ;
    }


#--------------------------------------------------
#  The line contains a region ID, so get the
#  region ID.

    $region_id = $street_name_or_region_id ;


#--------------------------------------------------
#  Currently this section is not used because the
#  earlier related section of code is skipped.
#
#  If this region is not getting full coverage, and
#  if the street ID is an older way ID number, or
#  older region ID number, ignore this street and
#  repeat the loop.  This approach yields only
#  older, less-recent, data for areas with expected
#  fewer users.
#
#  Currently the cutoff for older street IDs is at
#  way ID number 4,999,999.
#  Relation ID numbers can overlap with way ID
#  numbers, but there are far fewer street 
#  relations than street ways, so don't bother
#  using a different cutoff point for relation ID
#  numbers.

#    if ( not( exists( $yes_need_full_coverage_in_region_id{ $region_id } ) ) )
#    {
#        if ( ( length( $street_id ) > 7 ) || ( $street_id =~ /^[5-9][0-9][0-9][0-9][0-9][0-9][0-9]$/ ) )
#        {
#            next ;
#        }
#    }


#--------------------------------------------------
#  If the street name has not yet been written,
#  write it.

    if ( $yes_or_no_wrote_current_street_name != $yes_yes )
    {
        $yes_or_no_wrote_current_street_name = $yes_yes ;
        $category = 'pattern_' . substr( $street_id , -2 , 2 ) . '/' . substr( ( "000" . $street_id ) , -4 , 2 ) ;
        print OUT_STREET_NAMES $category . " " . $way_or_relation_type . $street_id . " " . $street_name . "\n" ;


#--------------------------------------------------
#  Also (if not already done) generate the
#  searchable words for this street name.
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
    }


#--------------------------------------------------
#  Write the street IDs and street names of streets
#  that are in that region.

   print OUT_REGION_STREET $region_id . " " . $way_or_relation_type . $street_id . " " . $street_name . "\n" ;


#--------------------------------------------------
#  For each region ID in which this street name is
#  used as part of an intersection name, write the
#  region ID, the searchable words, and the street
#  ID.  Verify the street word is not empty
#  because at least one street name begins with
#  an apostrophe that causes the first split word
#  to be empty.  Also do not write a word that
#  contains a question mark.

    @list_of_street_words = split( /_+/ , $modified_street_name ) ;
    foreach $street_word ( @list_of_street_words )
    {
        if ( ( $street_word =~ /[^ ]/ ) && ( $street_word !~ /\?/ ) )
        {
            print OUT_STREET_WORDS $region_id . " " . $street_word . " " . $way_or_relation_type . $street_id . "\n" ;
        }
    }


#--------------------------------------------------
#  Repeat the loop that handles the next input
#  line.

}


#--------------------------------------------------
#  Close the output files.

close( OUT_STREET_NAMES ) ;
close( OUT_STREET_WORDS ) ;
close( OUT_REGIONS_STREETS ) ;


#--------------------------------------------------
#  All done, end of main code.



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


#--------------------------------------------------
#  End of code.

