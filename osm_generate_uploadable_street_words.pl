#--------------------------------------------------
#       osm_generate_uploadable_street_words.pl
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
#  perl osm_generate_uploadable_street_words.pl

#--------------------------------------------------


#--------------------------------------------------
#  Sample input lines:

#  1023_9961 centralia w123
#  1023_9961 centralia w456
#  1023_9961 centralia r567
#  1024_9962 main w987


#--------------------------------------------------
#  Sample output line:

#  1023_9961 centralia w123 w456 r567


#--------------------------------------------------
#  Open the output file, and a log file.

$output_filename = "output_uploadable_street_words.txt" ;
open( OUT_FILE , ">" , $output_filename ) ;
print "creating output file " . $output_filename . "\n" ;

$output_filename = "output_log_from_generate_uploadable_street_words.txt" ;
open( OUT_LOG , ">" , $output_filename ) ;
print "creating log file " . $output_filename . "\n" ;


#--------------------------------------------------
#  Open the input file.

$input_filename = 'output_sorted_street_words.txt' ;
open( IN_FILE , "<" . $input_filename ) ;
print "reading input file " . $input_filename . "\n" ;


#--------------------------------------------------
#  Begin a loop that reads each line of the
#  input file.

$previous_region_id = "" ;
$previous_street_word = "" ;
while( $input_line = <IN_FILE> )
{
    chomp( $input_line ) ;


#--------------------------------------------------
#  Get the information from the line.  If the line
#  is not recognized, repeat the loop.

    if ( $input_line =~ /^([0-9]+_[0-9]+) ([^ ]+) ([wr][0-9]+)/ )
    {
        $region_id = $1 ;
        $street_word = $2 ;
        $street_id = $3 ;
    } else
    {
        print OUT_LOG "unrecognized line: " . $input_line . "\n" ;
        next ;
    }


#--------------------------------------------------
#  If the street word is just punctuation then
#  ignore it.  Also ignore times -- such as "00:03"
#  -- and distances -- such as "0.1km" and zeros
#  with punctuation -- such as ".0" and "-0" and
#  "0.".
#
#  Reminder: Street names of just one letter --
#  such as "K Street" -- can be significant.
#  Also some streets -- such as w6861166 named
#  Town Road Number 00003 -- use numbers with
#  leading zeros.

    if ( ( $street_word =~ /^[^&a-zA-Z0-9]+$/ ) || ( $street_word =~ /^[0-9]+:[0-9]+$/ ) || ( $street_word =~ /^[0-9]+\.[0-9]+km$/ )  || ( $street_word =~ /^[0\.\-]+$/ ) )
    {
        print OUT_LOG "ignored line: " . $input_line . "\n" ;
        next ;
    }


#--------------------------------------------------
#  If the region ID or street word is not the same
#  as in the previous line, write the accumulated
#  output line and start a new accumulated output
#  line using the new information, then repeat the
#  loop.  Avoid writing empty values.

    if ( ( $region_id ne $previous_region_id ) || ( $street_word ne $previous_street_word ) )
    {
        if ( length( $accumulated_output_line ) > 0 )
        {
            print OUT_FILE $accumulated_output_line . "\n" ;
        }
        $accumulated_output_line = $region_id . " " . $street_word . " " . $street_id ;
        $previous_region_id = $region_id ;
        $previous_street_word = $street_word ;
        $previous_street_id = $street_id ;
        next ;
    }


#--------------------------------------------------
#  The region ID and street word are the same as
#  in the previous line so append the new street
#  ID to the end of the accumulated output line.

    if ( $street_id ne $previous_street_id )
    {
        $accumulated_output_line .= " " . $street_id ;
    }


#--------------------------------------------------
#  Repeat the loop that handles the next input
#  line.

}


#--------------------------------------------------
#  Close the output files.

close( OUT_FILE ) ;
close( OUT_LOG ) ;


#--------------------------------------------------
#  All done.


