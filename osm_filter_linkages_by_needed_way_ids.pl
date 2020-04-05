#--------------------------------------------------
#       osm_filter_linkages_by_needed_way_ids.pl
#--------------------------------------------------

#  (c) Copyright 2014-2016 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:
#  perl osm_filter_linkages_by_needed_way_ids.pl < output_....txt
#
#  Do not specify output file, so that progress indications
#  can be watched.


#--------------------------------------------------
#  Specify the output filenames and path, and
#  input file size.

$input_file_byte_size = 47000000000 ;

$path_and_filename_list_of_found_way_ids = 'F:\CitiesBusinessesPostalCodesCongressionalDistricts\get_osm_and_postal\output_way_info_from_relations.txt' ;

$output_path_and_filename = 'F:\CitiesBusinessesPostalCodesCongressionalDistricts\get_osm_and_postal\output_linkages_of_interest.txt' ;


#--------------------------------------------------
#  Identify which way IDs are of interest.

open( INFILE , "<" . $path_and_filename_list_of_found_way_ids ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ / (w[0-9]+) / )
    {
        $way_id = $1 ;
        $yes_need_way_id{ $way_id } = "y" ;
    }
}


#--------------------------------------------------
#  Only write the lines that contain a way ID
#  of interest.
#  Periodically indicate progress.

open( OUTFILE , ">" . $output_path_and_filename ) ;

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ / (w[0-9]+) / )
    {
        $way_id = $1 ;
        if ( $progress_counter > 1000000 )
        {
            $now_at = tell( STDIN ) ;
            $percent_complete_tenths = sprintf( "%d" , int( 1000 * ( $now_at / $input_file_byte_size ) ) ) ;
            print $percent_complete_tenths . "\n" ;
            $progress_counter = 0 ;
        }
        $progress_counter ++ ;
        if ( exists( $yes_need_way_id{ $way_id } ) )
        {
            print OUTFILE $input_line . "\n" ;
        }
    }
}
