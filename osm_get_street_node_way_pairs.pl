#--------------------------------------------------
#       osm_get_street_node_way_pairs.pl
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
#  if there are arrangements for either business
#  to make donations to support the Open Street
#  Map project.
#  Disclaimer of Warranty:  THERE IS NO WARRANTY
#  FOR THIS SOFTWARE. THE COPYRIGHT HOLDER PROVIDES
#  THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY
#  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
#  BUT NOT LIMITED TO, THE FITNESS FOR A
#  PARTICULAR PURPOSE.
#  Limitation of Liability:  IN NO EVENT WILL THE
#  COPYRIGHT HOLDER BE LIABLE TO ANYONE FOR
#  DAMAGES, INCLUDING ANY GENERAL, SPECIAL,
#  INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
#  OUT OF THE USE OR INABILITY TO USE THE SOFTWARE.


#--------------------------------------------------
#  Usage:
#
#  perl osm_get_street_node_way_pairs.pl


#--------------------------------------------------
#  Sample input lines:

# s r93329 links_n196014427_n317852753_n15587131_n15587128_n18120526_ ... _w970282125_w12506832_w30506313_w930577679_w929754663_ Autostrada_del_Sole route_road  no_alt_name

# s w37 links_n200511_n1025338193_n177231081_n177081428_n1025338209_n177081440_n200512_n1025338201_n200514_n1025338210_n200517_n1025338191_n200515_n200526_n200527_n200528_n200530_n1082909509_n1082909488_n200532_n200533_n1082909478_n1082909485_n200534_n1082909513_n200535_n1082909475_n200536_n1082909486_n200537_n200539_n200541_n1082909501_n200540_n200543_n200542_n3364627862_n200544_n3364604949_n2715159904_ Maney_Hill_Road highway_residential  no_alt_name


#--------------------------------------------------
#  Sample output lines:

# n196014427 r93329

# n200511 w37


#--------------------------------------------------
#  Specify Linux or Windows path style.

# $slash_or_backslash = "\\" ;  # windows
$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Initialization.

$yes_yes = 1 ;
$no_no = 0 ;

for ( $ending_two_digits_as_integer = 0 ; $ending_two_digits_as_integer <= 99 ; $ending_two_digits_as_integer ++ )
{
    $yes_or_no_overwrite_output_for_digits[ $ending_two_digits_as_integer ] = $yes_yes ;
    $buffer_count_for_ending_digits[ $ending_two_digits_as_integer ] = 0 ;
}


#--------------------------------------------------
#  If the needed output directory does not exist,
#  create it.
#  The "p" switch, for "mkdir", specifies
#  "if it does not exist".

$command_to_execute = 'mkdir -p ./street_node_way_pairs > output_log_of_mkdir_messages.txt' ;
print "command to execute: " . $command_to_execute . "\n" ;
system( $command_to_execute ) ;


#--------------------------------------------------
#  Specify the output filename and its path.

$path_and_filename_prefix_for_output = 'street_node_way_pairs' . $slash_or_backslash . 'node_way_pairs_in_group_' ;
$path_and_filename_suffix_for_output = '.txt' ;


#--------------------------------------------------
#  Process the data from the street relation file.

$input_filename = 'output_street_relation_info_tagged_as_street.txt' ;
&handle_lines_in_file( ) ;


#--------------------------------------------------
#  Process the data from the street way file.

$input_filename = 'output_street_way_info_tagged_as_street.txt' ;
&handle_lines_in_file( ) ;


#--------------------------------------------------
#  End of main code.


#--------------------------------------------------
#  Subroutine handle_lines_in_file
#
#  This subroutine gets the needed info from one
#  input file.  Each line contains one pair of IDs.
#  Data is stored in buffers and then written
#  when the buffers have a significant amount of
#  lines to write.  Each buffer holds the info for
#  one category of node IDs where each category is
#  for the node IDs that have the same two
#  least-significant digits (in the node ID).

sub handle_lines_in_file
{
    print "input filename: " . $input_filename . "\n" ;
    open( IN_FILE , '<' , $input_filename ) ;
    $count_of_nodes = 0 ;
    $count_of_lines = 0 ;
    $interval_counter = 0 ;
    while( $input_line = <IN_FILE> )
    {
        chomp( $input_line ) ;
        if ( $input_line =~ /([wr][0-9]+).* links_([nw0-9_]+) / )
        {
            $way_or_relation_id = $1 ;
            $list_of_node_way_ids_as_text = $2 ;
            @list_of_node_way_ids = split( /_/ , $list_of_node_way_ids_as_text ) ;
            foreach $node_way_id ( @list_of_node_way_ids )
            {
                if ( $node_way_id =~ /n[0-9]*([0-9][0-9])/ )
                {
                    $ending_two_digits_as_integer = $1 + 0 ;
                    $output_lines_with_ending_digits[ $ending_two_digits_as_integer ] .= $node_way_id . " " . $way_or_relation_id . "\n" ;
                    $buffer_count_for_ending_digits[ $ending_two_digits_as_integer ] ++ ;
                    if ( $buffer_count_for_ending_digits[ $ending_two_digits_as_integer ] > 1000 )
                    {
                        &write_buffered_lines( ) ;
                    }
                    $count_of_nodes ++ ;
                }
            }
        }
        $count_of_lines ++ ;
    }
    &write_buffered_lines( ) ;
    close( IN_FILE ) ;
    print "got " . $count_of_nodes . " nodes from " . $count_of_lines . " lines" . "\n" ;
}


#--------------------------------------------------
#  Subroutine that writes buffered data.
#
#  This subroutine is used to write the output
#  info when there is enough info in the buffers.
#  If buffering were not used, each of the 100
#  output files would have to be opened and
#  closed just to write one line at a time.

sub write_buffered_lines
{
    for ( $ending_two_digits_as_integer = 0 ; $ending_two_digits_as_integer <= 99 ; $ending_two_digits_as_integer ++ )
    {
        if ( $buffer_count_for_ending_digits[ $ending_two_digits_as_integer ] > 0 )
        {
            $ending_two_digits_as_text = sprintf( "%02d" , $ending_two_digits_as_integer ) ;
            $output_filename = $path_and_filename_prefix_for_output . $ending_two_digits_as_text . $path_and_filename_suffix_for_output ;
            if ( $yes_or_no_overwrite_output_for_digits[ $ending_two_digits_as_integer ] == $yes_yes )
            {
                open( OUT_FILE , '>' , $output_filename ) ;
                $yes_or_no_overwrite_output_for_digits[ $ending_two_digits_as_integer ] = $no_no ;
            } else
            {
                open( OUT_FILE , '>>' , $output_filename ) ;
            }
            print OUT_FILE $output_lines_with_ending_digits[ $ending_two_digits_as_integer ] ;
            $output_lines_with_ending_digits[ $ending_two_digits_as_integer ] = '' ;
            $buffer_count_for_ending_digits[ $ending_two_digits_as_integer ] = 0 ;
            close( OUT_FILE ) ;
        }
    }
}


#--------------------------------------------------
#  End of code.
