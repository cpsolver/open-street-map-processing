#--------------------------------------------------
#       remove_duplicate_adjacent_lines.pl
#--------------------------------------------------

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line ne $previous_input_line )
    {
        print $input_line . "\n" ;
    }
    $previous_input_line = $input_line ;
}
