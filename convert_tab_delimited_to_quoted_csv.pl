#--------------------------------------------------
#   convert_tab_delimited_to_quoted_csv.pl
#--------------------------------------------------

#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com


while ( $input_line = <STDIN> ) {
    chomp ( $input_line ) ;
    $input_line =~ s/\t/","/g ;
    if ( $input_line ne "" )
    {
        print '"' . $input_line . '"' . "\n" ;
    }
}


