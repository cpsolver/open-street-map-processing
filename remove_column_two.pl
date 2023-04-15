#--------------------------------------------------
#       remove_column_two.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com


#--------------------------------------------------
#  Usage:

#  perl remove_column_two.pl < input_file.txt > output_file.txt


#--------------------------------------------------


while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([^ ]+) +[^ ]+(.*)/ )

#  older version did not work if only two columns:
#    if ( $input_line =~ /^([^ ]+) +[^ ]+ +([^ ].*[^ ])/ )

    {
        $first_column = $1 ;
        $remaining_columns = $2 ;
        if ( $remaining_columns =~ /[^ ]/ )
        {
            $remaining_columns =~ s/^ +// ;
            $remaining_columns =~ s/ +$// ;
            print $first_column . " " . $remaining_columns . "\n" ;
        } else
        {
            print $first_column . "\n" ;
        }
    }
}

