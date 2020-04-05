#--------------------------------------------------
#       osm_split_city_info_by_rank.pl
#--------------------------------------------------

#  (c) Copyright 2014 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Specify the path and beginning portion of the
#  output filenames.

$path_and_filename_prefix_for_city_ranked_info = "./temp_calcs/output_cities_with_rank_prefix_" ;


#--------------------------------------------------
#  Read each line in the file.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;


#--------------------------------------------------
#  Handle the splitting of CITY info based on
#  rank number.
#
#  Sample input line:
#      005 mon montebello 10456501299 10749397183 n2019181483 Montebello

    if ( $input_line =~ /^([0-9][0-9][0-9]) ([^ ].+)/ )
    {
        $city_rank_number = $1 ;
        $output_line = $2 ;
        $output_lines_for_city_rank_number{ $city_rank_number } .= $output_line . "\n" ;
        $count_lines_stored_ready_to_write ++ ;
        if ( $count_lines_stored_ready_to_write > 1000 )
        {
            foreach $city_rank_number ( keys( %output_lines_for_city_rank_number ) )
            {
                $output_lines = $output_lines_for_city_rank_number{ $city_rank_number } ;
                open OUTBUF , ">>" . $path_and_filename_prefix_for_city_ranked_info . $city_rank_number . '.txt' ;
                print OUTBUF $output_lines ;
                close OUTBUF ;
            }
            %output_lines_for_city_rank_number = ( ) ;
            $count_lines_stored_ready_to_write = 0 ;
        }
    }


#--------------------------------------------------
#  Repeat the loop for the next line in the file.

}


#--------------------------------------------------
#  Write the remaining contents of the buffers.

foreach $city_rank_number ( keys( %output_lines_for_city_rank_number ) )
{
    $output_lines = $output_lines_for_city_rank_number{ $city_rank_number } ;
    open OUTBUF , ">>" . $path_and_filename_prefix_for_city_ranked_info . $city_rank_number . '.txt' ;
    print OUTBUF $output_lines ;
    close OUTBUF ;
}
