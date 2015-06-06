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
$DEBUG = $TRUE;

# Main loop
while ($nextline = <STDIN>) {
	# Skip the blankos
	next if ($nextline =~ /^\s*$/);
	next if ($nextline =~ /^\**/);	
	# Skip the unreadables
	next if ($nextline =~ /unreadable|unknown/i);

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
		$rest =~ /(.*) +(\(.*\))/;
		$first = $1;
		$rest = $2;
		$rest =~ /\((.*)-(.*)\)/;
		$date1 = $1;
		$date2 = $2;
		print "Last: $last first: $first date1: $date1 date2: $date2\n";
		}
}
