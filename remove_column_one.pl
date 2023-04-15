#--------------------------------------------------
#       remove_column_one.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl remove_column_one.pl < input_file.txt > output_file.txt


#--------------------------------------------------


while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^[^ ]+ +([^ ].*[^ ])/ )
    {
        $remaining_columns = $1 ;
        print $remaining_columns . "\n" ;
    }
}

