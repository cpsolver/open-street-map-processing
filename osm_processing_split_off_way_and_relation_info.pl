#-------------------------------------------------
#
#       osm_processing_split_off_way_and_relation_info.pl
#
#  (c) Copyright 2023 by Richard Fobes at SolutionsCreative.com
#
#  This Perl script runs Linux commands that read
#  the planet database file and split off the way
#  data and the relation data into separate files,
#  which are compressed because they are huge.
#  This allows the relation data to be processed
#  before processing the way data, and allows the
#  way data to be processed before the node data.
#  This is needed because the planet database file
#  has the node data first, the way data second,
#  and the relation data last.
#
#  Usage:
#
#  perl osm_processing_split_off_way_and_relation_info.pl
#
#  To monitor progress, use the Linux "top"
#  command.  Also watch the file sizes increase.
#
#
#-------------------------------------------------
#  Verify that some needed files exist.

$filename_needed[ 1 ] = 'text_yes.txt' ;
$filename_needed[ 2 ] = 'text_no.txt' ;
$filename_needed[ 3 ] = 'no_content.txt' ;
$filename_needed[ 4 ] = 'planet-latest.osm.bz2' ;
for ( $pointer = 1 ; $pointer <= 4 ; $pointer ++ )
{
	if ( not( -e $filename_needed[ $pointer ] ) )
	{
		print "needed file named " . $filename_needed[ $pointer ] . " not found, so exiting" . "\n" ;
		exit ;
	}
}


#-------------------------------------------------
#  Create a compressed file that contains just the
#  way data.

system( 'cat text_yes.txt > yes_or_no_get_way_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'bzcat planet-latest.osm.bz2 | perl osm_filter_ways_relations_only.pl | bzip2 > planet_ways_relations_only.bz2' ) ;


#-------------------------------------------------
#  Create a compressed file that contains just the
#  relation data.

system( 'cat text_yes.txt > yes_or_no_get_relation_info.txt' ) ;
system( 'cat text_no.txt > yes_or_no_get_way_info.txt' ) ;
system( 'bzcat planet_ways_relations_only.bz2 | perl osm_filter_ways_relations_only.pl | bzip2 > planet_relations_only.bz2' ) ;
