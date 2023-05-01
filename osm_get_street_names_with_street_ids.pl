#--------------------------------------------------
#       osm_get_street_names_with_street_ids.pl
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
#  perl osm_get_street_names_with_street_ids.pl


#--------------------------------------------------
#  Sample input line, shortened:

#  s r8715 links_n1105988000_n1105987675_n1105987809_n1105987170_n1109390734_n1109390364_ ... _w25800773_w722583098_w581991454_w25800775_w94218567_w157274930_w311079359_ B&#252;mplizstrasse highway_secondary  no_alt_name

# s r93329 links_n196014427_n317852753_n15587131_n15587128_n18120526_ ... _w970282125_w12506832_w30506313_w930577679_w929754663_ Autostrada_del_Sole route_road  no_alt_name

# s w37 links_n200511_n1025338193_n177231081_n177081428_n1025338209_n177081440_n200512_n1025338201_n200514_n1025338210_n200517_n1025338191_n200515_n200526_n200527_n200528_n200530_n1082909509_n1082909488_n200532_n200533_n1082909478_n1082909485_n200534_n1082909513_n200535_n1082909475_n200536_n1082909486_n200537_n200539_n200541_n1082909501_n200540_n200543_n200542_n3364627862_n200544_n3364604949_n2715159904_ Maney_Hill_Road highway_residential  no_alt_name


#--------------------------------------------------
#  Sample output line:

#  pattern_64/50 w68895064 Senda_del_Mirador


#--------------------------------------------------
#  Specify Linux or Windows path style.

# $slash_or_backslash = "\\" ;  # windows
$slash_or_backslash = "/" ;  # linux


#--------------------------------------------------
#  Open the output file.

$output_filename = 'output_street_names_and_ids.txt' ;
open( OUT_FILE , '>' , $output_filename ) ;


#--------------------------------------------------
#  Get the street names from the way info.
#  These are first, before the relation names,
#  because relation streets tend to be freeways
#  and major highways, which are less meaningful
#  as intersections from a neighbor's or
#  traveler's point of view.

$input_filename = 'output_street_way_info.txt' ;

$input_filename = 'input_street_info.txt' ;

&handle_lines_in_file( ) ;


#--------------------------------------------------
#  Get the street names from the relation info.
#  Often the same name is associated with multiple
#  relation ID numbers.  This means that some
#  "intersections" are actually join points for a
#  long freeway or highway.
#  In 2022-Nov-2 there were about 180,000 lines of
#  output street names from relations.  

$input_filename = 'output_street_relation_info.txt' ;

# &handle_lines_in_file( ) ;


#--------------------------------------------------
#  End of main code.

close( OUT_FILE ) ;


#--------------------------------------------------
#  Subroutine handle_lines_in_file
#
#  Ascii code number 46 (decimal) is a period.

sub handle_lines_in_file
{
    print "input filename: " . $input_filename . "\n" ;
    open( IN_FILE , '<' , $input_filename ) ;
    while( $input_line = <IN_FILE> )
    {
        chomp( $input_line ) ;
        if ( $input_line =~ /([wr])([0-9]+) +links_[^ ]* +([^ ]+)/ )
        {
            $way_or_relation_type = $1 ;
            $id_number = $2 ;
            $street_name = $3 ;
            $street_name =~ s/&#46;/\./g ;
            $category = 'pattern_' . substr( $id_number , -2 , 2 ) . '/' . substr( ( "000" . $id_number ) , -4 , 2 ) ;
            print OUT_FILE $category . " " . $way_or_relation_type . $id_number . " " . $street_name . "\n" ;
        } else
        {
#           Write to standard output, not to output file:
            print "unrecognized line: " . $input_line . "\n" ;
        }
    }
    close( IN_FILE ) ;
}


#--------------------------------------------------
#  End of code.

