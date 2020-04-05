#--------------------------------------------------
#       osm_get_max_min_lats_lons.pl
#--------------------------------------------------

#  (c) Copyright 2014-2016 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_get_max_min_lats_lons.pl < input_file.txt

#  Do not specify output log file so that progress is
#  monitored in the terminal window.


#  sample output:
#  w294803649 10479885944 10146584806 



#--------------------------------------------------
#  Read each line of info, get the latitude and
#  longitude, and combine those numbers with other
#  latitudes and longitudes that are associated with
#  the same ID.

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    $data_type = "" ;

    if ( $input_line =~ /^(l) +([0-9]+) +([0-9]+) +(n[0-9]+) +(w[0-9]+) *$/ )
    {
        $data_type = $1 ;
        $latitude = $2 ;
        $longitude = $3 ;
        $intermediate_node_way_relation_id = $4 ;
        $node_way_relation_id = $5 ;
        $remainder_of_line = "" ;
    }

    if ( $data_type ne "" )
    {
        if ( exists( $max_latitude_for_id{ $node_way_relation_id } ) )
        {
            if ( $latitude > $max_latitude_for_id{ $node_way_relation_id } )
            {
                $max_latitude_for_id{ $node_way_relation_id } = $latitude ;
            }
            if ( $latitude < $min_latitude_for_id{ $node_way_relation_id } )
            {
                $min_latitude_for_id{ $node_way_relation_id } = $latitude ;
            }
            if ( $longitude > $max_longitude_for_id{ $node_way_relation_id } )
            {
                $max_longitude_for_id{ $node_way_relation_id } = $longitude ;
            }
            if ( $longitude < $min_longitude_for_id{ $node_way_relation_id } )
            {
                $min_longitude_for_id{ $node_way_relation_id } = $longitude ;
            }
        } else
        {
            $data_type_for_id{ $node_way_relation_id } = $data_type ;
            $max_latitude_for_id{ $node_way_relation_id } = $latitude ;
            $min_latitude_for_id{ $node_way_relation_id } = $latitude ;
            $max_longitude_for_id{ $node_way_relation_id } = $longitude ;
            $min_longitude_for_id{ $node_way_relation_id } = $longitude ;
            $remainder_of_line_for_id{ $node_way_relation_id } = $remainder_of_line ;
        }
    }

#    if ( $progress_counter > 100000 )
#    {
#        $input_byte_count = tell( STDIN ) ;
#        print "input byte count " . $input_byte_count . "\n" ;
#        $progress_counter = 0 ;
#    }
#    $progress_counter ++ ;

}


#--------------------------------------------------
#  Calculate the middle point of each item, and then
#  write the result along with the associated info.

foreach $node_way_relation_id ( keys( %max_latitude_for_id ) )
{
    $latitude_as_text = sprintf( "%011d" , int( ( $max_latitude_for_id{ $node_way_relation_id } + $min_latitude_for_id{ $node_way_relation_id } ) / 2 ) ) ;
    $longitude_as_text = sprintf( "%011d" , int( ( $max_longitude_for_id{ $node_way_relation_id } + $min_longitude_for_id{ $node_way_relation_id } ) / 2 ) ) ;
    print $node_way_relation_id . " " . $latitude_as_text . " " . $longitude_as_text . "\n" ;
#    print $data_type . " " . $node_way_relation_id . " " . $latitude_as_text . " " . $longitude_as_text . " " . $remainder_of_line . "\n" ;
}
