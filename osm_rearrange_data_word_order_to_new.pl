#----------------------------------------------------------------
#         osm_rearrange_data_word_order_to_new.pl
#----------------------------------------------------------------


#----------------------------------------------------

while ( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +([^ ].+)$/ )
    {
        $word_one = $1 ;
        $word_two = $2 ;
        $word_three = $3 ;
        $word_four = $4 ;
        $word_five = $5 ;
        $words_remaining = $6 ;

#  version for business node info, convert from old to new word order
        $output_line = "b " . $word_one . " " . $word_two . " " . $word_four . " " . $word_three . " " . $words_remaining . " " . $word_five ;

        $output_line =~ s/  +/ /g ;
        $output_line =~ s/ +$// ;
        print $output_line . "\n";
    }
}
