#----------------------------------------------------------------
#     generate_map_density_squares.pl
#----------------------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com


#----------------------------------------------------------------
#  Initialization.

$unit_integer_per_degree = 10000000 ;
$latitude_integer_offset = ( 1080 ) * $unit_integer_per_degree ;
$longitude_integer_offset = ( -820 ) * $unit_integer_per_degree ;
$latitude_degrees_per_category = 0.333333 ;
$longitude_degrees_per_category = 0.333333 ;
$maximum_downward_vertical_category = int( ( 160 * $unit_integer_per_degree ) / $latitude_degrees_per_category ) ;
$maximum_rightward_horizontal_category = int( ( 360 * $unit_integer_per_degree ) / $longitude_degrees_per_category ) ;
$downward_pixels_per_category = 1 ;
$rightward_pixels_per_category = 1 ;
$downward_pixel_offset = 100 ;
$rightward_pixel_offset = 20 ;
$pixel_width = 2 ;
$pixel_height = 2 ;
$maximum_count = -1 ;
$maximum_latitude_integer = -999999999999 ;
$minimum_latitude_integer = 999999999999 ;
$maximum_longitude_integer = -999999999999 ;
$minimum_longitude_integer = 999999999999 ;


#----------------------------------------------------------------
#  Read each line of the input file.

while ( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
#    print $input_line . "\n" ;


#----------------------------------------------------------------
#  Count the number of items in each category.

    if ( $input_line =~ /([0-9]{11}) +([0-9]{11})/ )
    {
        $latitude_integer = $1 ;
        $longitude_integer = $2 ;
        $downward_vertical_category = int( ( ( - $latitude_integer ) + $latitude_integer_offset ) / ( $unit_integer_per_degree * $latitude_degrees_per_category ) ) ;
        $rightward_horizontal_category = int( ( $longitude_integer + $longitude_integer_offset ) / ( $unit_integer_per_degree * $longitude_degrees_per_category ) ) ;
        $category = sprintf( "%d" , $downward_vertical_category ) . "_" . sprintf( "%d" , $rightward_horizontal_category ) ;
        if ( ( $downward_vertical_category > -1 ) && ( $downward_vertical_category <= $maximum_downward_vertical_category ) && ( $rightward_horizontal_category > -1 ) && ( $rightward_horizontal_category <= $maximum_rightward_horizontal_category ) )
        {
            $count_at_category{ $category } ++ ;
            if ( $count_at_category{ $category } > $maximum_count )
            {
                $maximum_count = $count_at_category{ $category }
            }
        }
#        print $latitude_integer . " " . $longitude_integer . " " . $category . "\n" ;


#----------------------------------------------------------------
#  For debugging.

        if ( $latitude_integer > $maximum_latitude_integer )
        {
            $maximum_latitude_integer = $latitude_integer ;
        }
        if ( $latitude_integer < $minimum_latitude_integer )
        {
            $minimum_latitude_integer = $latitude_integer ;
        }
        if ( $longitude_integer > $maximum_longitude_integer )
        {
            $maximum_longitude_integer = $longitude_integer ;
        }
        if ( $longitude_integer < $minimum_longitude_integer )
        {
            $minimum_longitude_integer = $longitude_integer ;
        }
    }


#----------------------------------------------------------------
#  Repeat the loop for the next input line.

}


#----------------------------------------------------------------
#  Write the results.

foreach $category ( keys( %count_at_category ) )
{
    $count = $count_at_category{ $category } ++ ;
    $opacity = sprintf( "%.2f" , ( 0.5 + ( 0.5 * ( log( $count ) / log( $maximum_count ) ) ) ) ) ;
    ( $downward_vertical_category , $rightward_horizontal_category ) = split( /_/ , $category ) ;
    $downward_vertical_position = ( $downward_vertical_category * $downward_pixels_per_category ) + $downward_pixel_offset ;
    $rightward_horizontal_position = ( $rightward_horizontal_category * $rightward_pixels_per_category ) + $rightward_pixel_offset ;
    $output_line = '<rect x="' . $rightward_horizontal_position . '" y="' . $downward_vertical_position . '" width="' . $pixel_width . '" height="' . $pixel_height . '" style="fill: #00b800; fill-opacity:' . $opacity . ';" />' ;
    print $output_line . "\n" ;
}


#----------------------------------------------------------------
#  For debugging, write high and low values.

#  result:  10782221712 09222273883 11793358189 08200015228
#  translation: +80 degrees and -80 degrees is latitude range, +/-180 degrees is longitude range

# print $maximum_latitude_integer . " " . $minimum_latitude_integer . " " . $maximum_longitude_integer . " " . $minimum_longitude_integer . "\n" ;
