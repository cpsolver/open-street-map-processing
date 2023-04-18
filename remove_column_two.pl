#--------------------------------------------------
#       remove_column_two.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com
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

