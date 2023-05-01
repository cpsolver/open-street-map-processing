#--------------------------------------------------
#       osm_join_intersection_info_files.pl
#--------------------------------------------------


$output_filename = 'output_joined_intersection_info_before_exclusions.txt' ;
print "output filename: " . $output_filename . "\n" ;
open( OUT_FILE , '>' , $output_filename ) ;
for ( $group_digit_as_integer = 0 ; $group_digit_as_integer <= 9 ; $group_digit_as_integer ++ )
{
    $group_digit_as_text = sprintf( "%01d" , $group_digit_as_integer ) ;
    $input_filename = 'output_intersections_with_lats_lons_group_' . $group_digit_as_text . '.txt' ;
    print "input filename: " . $input_filename . "\n" ;
    open( IN_FILE , '<' , $input_filename ) ;
    while( $input_line = <IN_FILE> )
    {
        chomp( $input_line ) ;
        print OUT_FILE $input_line . "\n" ;
    }
    close( IN_FILE ) ;
}
close( OUT_FILE ) ;
