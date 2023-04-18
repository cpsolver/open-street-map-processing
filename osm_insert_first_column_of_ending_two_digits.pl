#--------------------------------------------------
#       osm_insert_first_column_of_ending_two_digits.pl
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
#  if they also arrange to make donations to
#  support the Open Street Map project.


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

