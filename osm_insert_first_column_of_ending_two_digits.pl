#--------------------------------------------------
#       osm_insert_first_column_of_ending_two_digits.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl osm_insert_first_column_of_ending_two_digits.pl < input_file.txt > output_file.txt


#--------------------------------------------------


while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([^ ]+([0-9][0-9])) +(.*[^ ])/ )
    {
        $item_id = $1 ;
        $ending_two_digits = $2 ;
        $remainder_of_line = $3 ;
        print $ending_two_digits . " " . $item_id . " " . $remainder_of_line . "\n" ;
    }
}

