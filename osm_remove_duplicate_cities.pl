#--------------------------------------------------
#       osm_remove_duplicate_cities.pl
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


$yes_yes = 1 ;
$no_no = 0 ;
while( $input_line = <STDIN> )
{
    chomp( $input_line ) ;
    if ( $input_line =~ /^([^ ]+ [^ ]+ [^ ]+)/ )
    {
        $city_abbreviated_name_and_state_and_country = $1 ;
        if ( $abbreviated_name_and_state_and_country_already_used{ $city_abbreviated_name_and_state_and_country } == $yes_yes )
        {
            next ;
        }
        $abbreviated_name_and_state_and_country_already_used{ $city_abbreviated_name_and_state_and_country } = $yes_yes ;
        print $input_line . "\n" ;
    }
}
