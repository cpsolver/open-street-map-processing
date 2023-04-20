#--------------------------------------------------
#       osm_convert_lats_lons_to_decimal.pl
#--------------------------------------------------
#
#  Converts latitudes and longitudes from "nines
#  complement" notation into standard decimal
#  notation.
#
#  Usage:
#
#  perl osm_convert_lats_lons_to_decimal.pl < input_file.txt > output_file.txt
#
#  This simple script has no copyright notice
#  because anyone can use it for any reasonable
#  data processing purpose.
#  

#--------------------------------------------------
#  Clarification:
#
#  For faster processing and reduced disk storage
#  space requirements, the "osm" Perl scripts
#  convert latitudes and longitudes into positive
#  integers without a decimal point.  At the end
#  of processing this script converts those
#  latitudes and longitudes back into standard
#  decimal notation.
#
#  To convert the integer version of a latitude
#  or longitude back into a signed decimal number,
#  Look at the first digit.  If it is "1" then
#  remove the "1" and insert a decimal point to
#  the left of the right-most eight digits.
#  If the first digit is "0" then put a minus
#  sign at the beginning and convert each digit
#  to its "nines complement" value.
#
#  The "nines complement" conversion changes each
#  "9" to "0", each "8" to "1", each "7" to "2",
#  etc. down to each "2" to "7", each "1" to "8",
#  and each "0" to "9".  Using this convention
#  causes the numbers to have smooth transitions
#  at the equator (10000000000) and zero meridian
#  (10000000000).  Specifically the next point in
#  the negative direction is "09999999999".
#  Note that these conversions are text-based so
#  they do not involve converting to or from
#  software-based "integers".

while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    $output_line = $input_line ;
    if ( $input_line =~ /^(.*)([0-9])([0-9]{3})([0-9]{7}) ([0-9])([0-9]{3})([0-9]{7})(.*)$/ )
    {
        $prefix = $1 ;
        $latitude_first_digit = $2 ;
        $latitude_digits_left_of_decimal_point = $3 ;
        $latitude_digits_right_of_decimal_point = $4 ;
        $longitude_first_digit = $5 ;
        $longitude_digits_left_of_decimal_point = $6 ;
        $longitude_digits_right_of_decimal_point = $7 ;
        $suffix = $8 ;
        $latitude_sign = "" ;
        $longitude_sign = "" ;
        if ( $latitude_first_digit eq "0" )
        {
            $latitude_sign = "-" ;
            $latitude_digits_left_of_decimal_point =~ tr/0123456789/9876543210/ ;
            $latitude_digits_right_of_decimal_point =~ tr/0123456789/9876543210/ ;
        }
        if ( $longitude_first_digit eq "0" )
        {
            $longitude_sign = "-" ;
            $longitude_digits_left_of_decimal_point =~ tr/0123456789/9876543210/ ;
            $longitude_digits_right_of_decimal_point =~ tr/0123456789/9876543210/ ;
        }
        $latitude_digits_left_of_decimal_point =~ s/^0+// ;
        $longitude_digits_left_of_decimal_point =~ s/^0+// ;
        if ( $latitude_digits_left_of_decimal_point eq "" )
        {
            $latitude_digits_left_of_decimal_point = "0" ;
        }
        if ( $longitude_digits_left_of_decimal_point eq "" )
        {
            $longitude_digits_left_of_decimal_point = "0" ;
        }
        $latitude_decimal = $latitude_sign . $latitude_digits_left_of_decimal_point . "." . $latitude_digits_right_of_decimal_point ;
        $longitude_decimal = $longitude_sign . $longitude_digits_left_of_decimal_point . "." . $longitude_digits_right_of_decimal_point ;
        $output_line = $prefix . $latitude_decimal . " " . $longitude_decimal . $suffix ;
    }
    print $output_line . "\n" ;
}
