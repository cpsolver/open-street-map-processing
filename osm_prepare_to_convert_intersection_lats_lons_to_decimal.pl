#--------------------------------------------------
#       osm_prepare_to_convert_intersection_lats_lons_to_decimal.pl
#--------------------------------------------------

#  Usage:

#  perl osm_prepare_to_convert_intersection_lats_lons_to_decimal.pl < input_file.txt > output_file.txt


#--------------------------------------------------
#  Input format:

#  0956_1172 w4727746 w4727819 5426401 6243351


#--------------------------------------------------
#  Output format:

#  w4727746 w4727819 09565426401 11726243351


#--------------------------------------------------


while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /([0-9]{4})_([0-9]{4}) +([wr][0-9]+ +[wr][0-9]+) +([0-9]{7}) +([0-9]{7})/ )
    {
        $latitude_begin = $1 ;
        $longitude_begin = $2 ;
        $two_street_ids = $3 ;
        $latitude_end = $4 ;
        $longitude_end = $5 ;
        print $two_street_ids . " " . $latitude_begin . $latitude_end . " " . $longitude_begin . $longitude_end . "\n" ;
    }
}
