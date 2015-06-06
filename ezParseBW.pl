#!/usr/bin/perl

###
### ezParse.pl: Parse a walkaround file
###
### Written 1 December 2011 BLC
###

# I like to explicitly mark booleans
$TRUE = 1;
$FALSE = 0;

# Initialize variables

# This will soon be a command-line flag
$FULL = $FALSE;

# And this controls debugging output
$DEBUG = $FALSE;

# Main loop
while ($nextline = <STDIN>) {
	next if ($nextline =~ /^\s*$/);
	# We know the first line is always locational

	# Chop leading whitespace
	for ($nextline) {
		s/^\s+//;
		print $nextline if $DEBUG;
		}
	
	if ($nextline =~ /.*-.*-.*-.*/) { # It's a location
		# Here is where to parse the location if needed
		print "Location: $nextline\n" if $DEBUG;
	} else {
		# We know it's a person line; here is the bulk of your work
		print "Person: $nextline" if $DEBUG;
		($last, $rest) = split (/,/,$nextline);
		print "Last: $last rest: $rest\n" if $DEBUG;
		$rest =~ /(.*) +\((\d{1,2}\/\d{1,2}\/\d{4}|\d{4}|\?)\s*-\s*(\d{1,2}\/\d{1,2}\/\d{4}|\d{4}|\?)\)/;
		$first = $1;
		$bdate = $2;
                $ddate = $3;

                #if ($last =~ "Total of \d{1,2} Rows"){
		#	print "$nextline\n" if $DEBUG;
                #}
                #if ($ddate =~ "\?"){
                #        print "$last | $first | $bdate\n";
                #}
                if ($last =~ "UNREADABLE-UNKNOWN"){
                        print "$last";
                }else{
                        print "$last | $first | $bdate | $ddate\n";
                }
	}
}
