#--------------------------------------------------
#       osm_filter_ways_relations_only.pl
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
#  Extracts just way and relation info from
#  XML data file planet-latest.osm.bz2
#
#  Currently this script is only used to get
#  relation info because a different script is used
#  to get the way (and relation) info.
#
#  Usage:

# cat text_yes.txt > yes_or_no_get_relation_info.txt
# cat text_no.txt > yes_or_no_get_way_info.txt
# bzcat planet_ways_relations_only.bz2 | perl osm_filter_ways_relations_only.pl | bzip2 > planet_relations_only.bz2


#--------------------------------------------------
#  Initialization.

$yes_yes = 1 ;
$no_no = 0 ;


#--------------------------------------------------
#  Specify which data is being extracted.
#  Do not log this choice because it will show up
#  in the compressed output data file.

$yes_or_no_get_way_info = $no_no ;
$yes_or_no_get_relation_info = $no_no ;
open( INFILE , "<" . "yes_or_no_get_way_info.txt" ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /yes/ )
    {
        $yes_or_no_get_way_info = $yes_yes ;
    }
}
close( INFILE ) ;
open( INFILE , "<" . "yes_or_no_get_relation_info.txt" ) ;
while( $input_line = <INFILE> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /yes/ )
    {
        $yes_or_no_get_relation_info = $yes_yes ;
    }
}
close( INFILE ) ;
if ( $yes_or_no_get_way_info == $yes_yes )
{
    $yes_or_no_get_relation_info = $no_no ;
}
if ( ( $yes_or_no_get_way_info == $no_no ) && ( $yes_or_no_get_relation_info == $no_no ) )
{
    print "neither way nor relation info requested, so exiting" . "\n" ;
    exit ;
}


#--------------------------------------------------
#  Get the requested lines.

$line_counter = 0 ;
$yes_or_no_found_match = $no_no ;
while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    $line_counter ++ ;
    if ( $yes_or_no_found_match == $no_no )
    {
        if ( $yes_or_no_get_way_info == $yes_yes )
        {
            if ( index( $input_line , "<way" ) >= 0 )
            {
                print "skipped " . $line_counter . " lines" . "\n\n" ;
                print $input_line . "\n" ;
                $yes_or_no_found_match = $yes_yes ;
            }
        } elsif ( $yes_or_no_get_relation_info == $yes_yes )
        {
            if ( index( $input_line , "<relation" ) >= 0 )
            {
                print "skipped " . $line_counter . " lines" . "\n\n" ;
                print $input_line . "\n" ;
                $yes_or_no_found_match = $yes_yes ;
            }
        }
    } else
    {
        print $input_line . "\n" ;
    }
}

