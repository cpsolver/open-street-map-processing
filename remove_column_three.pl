#--------------------------------------------------
#       remove_column_three.pl
#--------------------------------------------------

#  (c) Copyright 2022 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl remove_column_three.pl < input_file.txt > output_file.txt


#--------------------------------------------------


while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([^ ]+ +[^ ]+) +[^ ]+(.*)/ )
    {
        $first_two_columns = $1 ;
        $remaining_columns = $2 ;
        if ( $remaining_columns =~ /[^ ]/ )
        {
            $remaining_columns =~ s/^ +// ;
            $remaining_columns =~ s/ +$// ;
            print $first_two_columns . " " . $remaining_columns . "\n" ;
        } else
        {
            print $first_two_columns . "\n" ;
        }
    }
}

