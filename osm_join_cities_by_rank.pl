#--------------------------------------------------
#       osm_join_cities_by_rank.pl
#--------------------------------------------------

#  (c) Copyright 2014 by Richard Fobes at NewsHereNow.com


#---------------------------------------------------
#  Create the list of files that need to be
#  combined.

$directory = "./temp_calcs/" ;
if ( opendir( READDIR , $directory ) )
{
    while ( defined( $file_name = readdir( READDIR ) ) )
    {
        if ( $file_name =~ /output_cities_with_rank_prefix_[0-9]+\.txt/i )
        {
            push( @list_of_city_info_files , $file_name ) ;
        }
    }
    closedir( READDIR ) ;
}


#--------------------------------------------------
#  Starting with the file that contains the highest
#  rank value, open each file for reading.
#  Handle the files in sequence, starting with the
#  highest-ranked cities.

foreach $file_name ( reverse( sort( @list_of_city_info_files ) ) )
{

#    print "\n\n\n" ;
#    print $file_name . "\n" ;
#    print "\n\n\n" ;

    open( INFILE , "<" . $directory . $file_name ) ;


#--------------------------------------------------
#  Copy each line of the file.

    while( $input_line = <INFILE> )
    {
        chomp( $input_line ) ;
        print $input_line . "\n" ;
    }


#--------------------------------------------------
#  Close the input file, then repeat the loop to
#  handle the next input file.

    close( INFILE ) ;
}
