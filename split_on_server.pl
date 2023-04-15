#--------------------------------------------------
#       split_on_server.pl
#--------------------------------------------------

#  (c) Copyright 2014-2016 by Richard Fobes at SolutionsCreative.org
#  Special permission for use on NewsHereNow.com website is hereby granted.


#--------------------------------------------------
#  After split and uploading to new directory,
#  rename directories so that old data is
#  effectively moved to a different directory,
#  and the new directory becomes the one that is
#  used for lookups.


#--------------------------------------------------
#  This script now only works on Linux, not on
#  MS Windows.

$slash_or_backslash = '/' ;


#--------------------------------------------------
#  Specify the output filename prefixes.

$filename_prefix_for_info_type{ "cities" } = "cities_category_" ;
$filename_prefix_for_info_type{ "businesses" } = "businesses_category_" ;
$filename_prefix_for_info_type{ "postal_codes" } = "postal_codes_category_" ;
$filename_prefix_for_info_type{ "intersections" } = "intersections_category_" ;
$filename_prefix_for_info_type{ "street_names" } = "street_names_category_" ;
$filename_prefix_for_info_type{ "street_words" } = "street_words_category_" ;


#--------------------------------------------------
#  Specify the output path prefixes.
#
#  The path MUST begin with "./" !!!

$path_prefix_for_info_type{ "businesses" } = "./businesses_new/" ;
$path_prefix_for_info_type{ "cities" } = "./cities_new/" ;
$path_prefix_for_info_type{ "postal_codes" } = "./postal_codes_new/" ;
$path_prefix_for_info_type{ "intersections" } = "./intersections_new/" ;
$path_prefix_for_info_type{ "street_names" } = "./street_names_new/" ;
$path_prefix_for_info_type{ "street_words" } = "./street_words_new/" ;


#--------------------------------------------------
#  For output files, specify no read or write
#  permissions for non-owner.

umask( 0077 ) ;


#--------------------------------------------------
#  Initialization.

$info_type = "" ;
$target_filename = "" ;
%yes_exists_directory = ( ) ;
$yes_exists_directory{ '.' } = "yes" ;


#--------------------------------------------------
#  Read each line in the file.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    $line_count ++ ;


#--------------------------------------------------
#  Convert Unicode 58 into ":" character.

    $input_line =~ s/&58;/:/gs ;


#--------------------------------------------------
#  Remove any special characters at the end of
#  the line.  Ignore empty lines.

    $input_line =~ s/[ \t\n\r]+$//s ;
    if ( $input_line =~ /^ *$/ )
    {
        next ;
    }


#--------------------------------------------------
#  At the first line, determine which type of info
#  this is.
#
#  Example of type: intersection
#      0922_1166 w133795298 w191725117 1547107 6695210
#
#  Examples of type: city
#      paris ?? fr 10488565056 10023521334 n17807753 Paris
#
#  Example of type: street_name
#      pattern_64/50 w68895064 Senda_del_Mirador
#
#  Example of type: postal_code
#      99501 10612116000 08501238999 Anchorage_AK
#      r0b 10562701000 09030881999 Northern_Manitoba_&#40;Norway_House&#41;_MB
#
#  Example of type: business
#      b 10508875000 09983816599 n271078 Acres_Down_Farm tea_shop
#
#  Example of type: street_word
#      0944_0932 circuito w148131163 w148131166

    if ( $info_type eq "" )
    {
        if ( $input_line =~ /^[0-9]+[ _][0-9]+ [wr][0-9]+ [wr][0-9]+ [0-9]+ [0-9]+ *$/ )
        {
            $info_type = "intersections" ;
        } elsif ( $input_line =~ /^[^ ]+ [^ ]+ [a-zA-Z\?][a-zA-Z\?] [0-9]+ [0-9]+ [nwr][0-9]+ [^ ]+ *$/ )
        {
            $info_type = "cities" ;
        } elsif ( $input_line =~ /^pattern_[0-9a-z][0-9a-z][\\\/][0-9a-z][0-9a-z] [wr][0-9]+ [^ ]+ *$/ )
        {
            $info_type = "street_names" ;
        } elsif ( $input_line =~ /^[^ ]*[0-9][^ ]* [0-9]+ [0-9]+ [^ ]+ *$/ )
        {
            $info_type = "postal_codes" ;
        } elsif ( $input_line =~ /^b [0-9]+ [0-9]+ [nwr][0-9]+ [^ ].+ *$/ )
        {
            $info_type = "businesses" ;
        } elsif ( $input_line =~ /^[0-9]+[ _][0-9]+ [^ ]+ [wr][0-9]+/ )
        {
            $info_type = "street_words" ;
        }
        if ( exists( $filename_prefix_for_info_type{ $info_type } ) )
        {
            $filename_prefix = $filename_prefix_for_info_type{ $info_type } ;
            $path_prefix = $path_prefix_for_info_type{ $info_type } ;
        } else
        {
            print "first line is not recognized according to info type" . "\n\n" ;
            print "input line:  " . $input_line . "\n" ;
            exit ;
        }
        print "first input line:  " . $input_line . "\n" ;
        print "first line is recognized as info type: " . $info_type . "\n\n" ;
    }


#--------------------------------------------------
#  Determine the category that specifies the target
#  directory and filename, and get the line content
#  that will be written to the file.

    $output_line = "" ;
    if ( $info_type eq "intersections" )
    {
        if ( $input_line =~ /^([0-9]+)[ _]([0-9]+) ([wr][0-9]+) ([wr][0-9]+) ([0-9]{7}) ([0-9]{7}) *$/ )
        {
            $latitude_most_significant_digits = $1 ;
            $longitude_most_significant_digits = $2 ;
            $way_one = $3 ;
            $way_two = $4 ;
            $latitude_least_significant_digits = $5 ;
            $longitude_least_significant_digits = $6 ;
            $subdirectories = "lat9_" . $latitude_most_significant_digits . $slash_or_backslash ;
            $category = $latitude_most_significant_digits . "_" . $longitude_most_significant_digits ;
            $output_line = $way_one . " " . $way_two . " " . $latitude_least_significant_digits . " " . $longitude_least_significant_digits ;
        }
    } elsif ( $info_type eq "cities" )
    {
        if ( $input_line =~ /^(([^ ]+) [^ ].*[^ ]) *$/ )
        {
            $city_info = $1 ;
            $city_name_searchable = $2 ;
            $subdirectories = "" ;
# reminder: category for "miami" is "mm1"
            $category = $city_name_searchable ;
            $category =~ s/[^a-z0-9]+//g ;
            $category =~ s/[aeiou01]+//g ;
            $category = $category . "100" ;
            $category = substr( $category , 0 , 3 ) ;
            $output_line = $city_info ;
        }
    } elsif ( $info_type eq "street_names" )
    {
        if ( $input_line =~ /^pattern_([0-9a-z][0-9a-z])[\\\/]([0-9a-z][0-9a-z]) ([wr][0-9]+ [^ ]+) *$/ )
        {
            $pattern_number = $1 ;
            $sub_pattern_number = $2 ;
            $remainder_of_info = $3 ;
            $subdirectories = "pattern_" . $pattern_number . $slash_or_backslash ;
            $category = $sub_pattern_number . $pattern_number ;
            $output_line = $remainder_of_info ;
        }
    } elsif ( $info_type eq "postal_codes" )
    {
        if ( $input_line =~ /^([^ ]*[0-9][^ ]*) ([0-9]+ [0-9]+ [^ ]+) *$/ )
        {
            $postal_code = $1 ;
            $remainder_of_info = $2 ;
            $subdirectories = "" ;
            $category = substr( $postal_code , 0 , 2 ) ;
            $remainder_of_postal_code = substr( $postal_code , 2 ) ;
            $output_line = $remainder_of_postal_code . " " . $remainder_of_info ;
        }
    } elsif ( $info_type eq "businesses" )
    {
        $remainder_of_info = "" ;
        if ( $input_line =~ /^b ([0-9]{4})([0-9]{7}) ([0-9]{4})([0-9]{7}) ([nwr][0-9]+) ([^ ]+)(.*)$/ )
        {
            $latitude_most_significant_digits = $1 ;
            $latitude_least_significant_digits = $2 ;
            $longitude_most_significant_digits = $3 ;
            $longitude_least_significant_digits = $4 ;
            $id_number = $5 ;
            $name = $6 ;
            $remainder_of_info = $7 ;
            $subdirectories = "lat9_" . $latitude_most_significant_digits . $slash_or_backslash ;
            $category = $latitude_most_significant_digits . "_" . $longitude_most_significant_digits ;
            $output_line = $id_number . " " . $name . " " . $latitude_most_significant_digits . $latitude_least_significant_digits . " " . $longitude_most_significant_digits . $longitude_least_significant_digits . $remainder_of_info ;
        }
    } elsif ( $info_type eq "street_words" )
    {
        if ( $input_line =~ /^([0-9]+)[ _]([0-9]+) ([^ ]+ [wr][0-9]+.*)$/ )
        {
            $latitude_most_significant_digits = $1 ;
            $longitude_most_significant_digits = $2 ;
            $remainder_of_info = $3 ;
            $subdirectories = "lat9_" . $latitude_most_significant_digits . $slash_or_backslash ;
            $category = $latitude_most_significant_digits . "_" . $longitude_most_significant_digits ;
            $output_line = $remainder_of_info ;
        }
    } elsif ( $input_line =~ /[^ ]/ )
    {
        print "line not recognized as type " . $info_type . ":  " . $input_line . "\n" ;
        $error_count ++ ;
        if ( $error_count > 9 )
        {
            print "early exit" . "\n" ;
            exit ;
        }
        next ;
    }


#--------------------------------------------------
#  Append this line of info to the appropriate
#  data-specific file.

    $target_filename = $path_prefix . $subdirectories . $filename_prefix . $category . '.txt' ;
    $output_lines_for_file_name{ $target_filename } .= $output_line . "\n" ;
    $count_lines_stored_ready_to_write ++ ;


#--------------------------------------------------
#  Indicate what's happening at the beginning.

    if ( $line_count <= 10 )
    {
        print "line " . $line_count . " recognized as type " . $info_type . ":  " . $input_line . "\n" ;
        print "target_filename:  " . $target_filename . "\n\n" ;
    }


#--------------------------------------------------
#  Optional debugging code.
#  Comment-out to disable.

#    if ( $line_count > 9 )
#    {
#        print "just debugging, so early exit" . "\n" ;
#        exit ;
#    }
#    next ;


#--------------------------------------------------
#  Specify how many lines of info are written each
#  time a file is opened.  For the first few lines,
#  write each line each time through this loop.

    if ( $line_count > 10 )
    {
        $number_of_lines_to_write_each_time_file_is_opened = 100000 ;
    } else
    {
        $number_of_lines_to_write_each_time_file_is_opened = 1 ;
    }


#--------------------------------------------------
#  As needed, write the accumulated lines to the
#  output files.

    if ( $count_lines_stored_ready_to_write > $number_of_lines_to_write_each_time_file_is_opened )
    {
        foreach $target_filename ( keys( %output_lines_for_file_name ) )
        {
            $output_lines = $output_lines_for_file_name{ $target_filename } ;
            if ( $line_count < 11 )
            {
                print "debug, target_filename:  " . $target_filename . "\n" ;
                print "debug, output_lines:  " . $output_lines . "\n\n" ;
            }
            &write_output_lines_to_target_filename( ) ;
        }
        %output_lines_for_file_name = ( ) ;
        $count_lines_stored_ready_to_write = 0 ;
    }


#--------------------------------------------------
#  Repeat the loop for the next line in the file.

}


#--------------------------------------------------
#  Write any content that remains in the buffers.

foreach $target_filename ( keys( %output_lines_for_file_name ) )
{
    $output_lines = $output_lines_for_file_name{ $target_filename } ;
    &write_output_lines_to_target_filename( ) ;
}


#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
#  Subroutine that writes the contents of the
#  output_lines variable to the file named by
#  the variable target_filename, while also
#  creating any needed subdirectories.
#--------------------------------------------------

sub write_output_lines_to_target_filename
{


#--------------------------------------------------
#  Verify non-empty path and filename.

    if ( substr( $target_filename , 0 , 2 ) ne ( '.' . $slash_or_backslash ) )
    {
        print "invalid filename (" . $target_filename . ") so early exit" . "\n" ;
        exit ;
    }


#--------------------------------------------------
#  If the path involves any new directories/folders,
#  create them.
#
#  IMPORTANT:
#  This is safe only if the above code uses the
#  current directory ("./") as the starting part of
#  the path.

    $growing_path = "" ;
    $remaining_path = $target_filename ;
    while ( $remaining_path =~ /^([^ \/\\]+)[\/\\](.*)$/ )
    {
        $next_directory = $1 ;
        $remaining_path = $2 ;
        $growing_path .= $next_directory ;
        if ( not( exists( $yes_exists_directory{ $growing_path } ) ) )
        {
            if ( -d $growing_path )
            {
                $yes_exists_directory{ $growing_path } = "yes" ;
            } else
            {
                mkdir( $growing_path ) ;
                print "folder " . $growing_path . " created" . "\n" ;
                $yes_exists_directory{ $growing_path } = "yes" ;
            }
        }
        $growing_path .= $slash_or_backslash ;
    }
    $target_filename = $growing_path . $remaining_path ;


#--------------------------------------------------
#  Write the output information.

    open OUTBUF , ">>" . $target_filename ;
    print OUTBUF $output_lines ;
    close( OUTBUF ) ;


#--------------------------------------------------
#  End of subroutine.

}
