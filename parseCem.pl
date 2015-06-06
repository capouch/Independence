#!/usr/bin/perl

###
### parseCem.pl: Parse a cemetery reading file 
###		 and add markup tags
###
### Written 12 November 2011 BLC
### Update to handle lifedates begun 17 Nov 11
###

# I like to explicitly mark booleans
$TRUE = 1;
$FALSE = 0;

# Initialize variables
$section = "";
$subsection = "";
$row = 0;
$pos = 1;
$plusChar = "";
$missingChar = "";
$stoneCount = 0;
$graveCount = 0;
$first = $TRUE;
$inNote = $FALSE;

# Set a string to set a section/subsection prefix on short output
$prefix = "2-1-";

# This will soon be a command-line flag
$FULL = $FALSE;

# And this controls debugging output
$DEBUG = $FALSE;

# Main loop
while ($nextline = <STDIN>) {

	# Chop leading whitespace
	for ($nextline) {
		s/^\s+//;
		}


	# Is this a Section/Subsection/Row/Set-Row Delimiter?
	if (($nextline =~ /^\*.*/) || ($nextline =~ /^#.*/)) {
		# print "Got in here with $nextline";
		if ($nextline =~ /^\*\*\*/) {
			# print "GOT SECTION\n";
			$section++;
			$nextline =~ s/^...//;
			$sectionName = $nextline;
			print "SECTION: $sectionName\n" if $FULL;
			next;
			}
		elsif ($nextline =~ /^\*\*/) {
			# print "GOT SUBSECTION\n";
			$subsection++;
			$nextline =~ s/^..//;
			$subsecName = $nextline;
			print "SUBSECTION: $subsecName\n" if $FULL;
			next;
			}
		elsif ($nextline =~ /^\*.*/) {
			# print "GOT ROW: $nextline\n"; 
			$row++;
			$pos = 1;
			print "***************************************\n" if $FULL;
			print "ROW: $row\n\n" if $FULL;
			next;
			}
		elsif ($nextline =~ /^#(.*)/) {
			# Set new row number
			# print "GOT CHANGE\n";
			# Adjust for auto-increment too
			$row = $1 - 1;
			next;
			}
		else {
			next;
			}
		}			
	
	# A blank line means we have accumulated one record
	if ($nextline =~ /^\s*$/ ) {
		# Line break
		# print "Got break\n";
		# print "PARAGRAPH: ";

		# We have to eliminate lines w/only a LF, and NOTEs
		# but print anything else
		if (!($paragraph =~ /^$/ || $paragraph =~ /NOTE/)) {
			$stoneCount++;
			$graveCount++;
			print "$row-$pos$plusChar$missingChar. $paragraph\n\n"if $FULL;
			print "$prefix$row-$pos:\n$listing\n\n" if !$FULL;
			$pos++;
			$plusChar = "";
			$missingChar = "";
			$listing = "";
			}
		$inNote = $FALSE;	
		$paragraph = "";
		$plusCount = 0;
		$minusCount = 0;
		$first = $TRUE;
		
		# HACK: If this was a note, remove one from pos count
		if ($paragraph =~ /^NOTE.*/) {
			$pos--;
			}
		
	} else {
		# Hook for extracting "official" names 
		# print "Pre-processing: $nextline\n";
		if ($nextline =~ /NOTE/) {
			$inNote = $TRUE;
			}
		if ($nextline =~ /^\?.*/) { 	# Unreadable unknown
			$first = $FALSE;
			$listing = "UNREADABLE-UNKNOWN";
			}
		if ($first && !$inNote) {
			# print "Processing $nextline";
			$first = $FALSE;
			next if $nextline =~ /NOTE/;
			($official,$dates1,$rest) = split(/:/, $nextline);
			($surname, $rest) = split(/,/, $official);
			# Trim date string
			$dates1 =~ s/^\s+//;
			$listing = $listing  .  $official;
			$listing .= " \($dates1\)" if ($dates1 ne "");
			#print "FIRST: $official and $surname\n";
			}

		# See if this is a multi-person grave
		if ($nextline =~ /^\+.*/) {
			($official,$dates2,$rest) = split(/:/, $nextline);
			# Cut the plus char
			($junk, $official) = split (/\+/, $official);
			#print "EXTRA: $surname, $official\n";
		
			# Trim up date string
			$dates2 =~ s/^\s+//;	
			# Special case of different surnames
			# This regex seems so wrong. . 
			print "DEBUG:  $dates2\n" if $DEBUG;
			if ($official =~ /^([A-Z][A-Z]+|Mc[A-Z][A-Z]+|Mc[A-Z][A-Z]+|De[A-Z][A-Z]+)/) {
				# print "Processing $official\n";
				$listing = $listing ."\n$official";
				$listing = $listing . " \($dates2\) " if ($dates2 ne "");
				}
			else {
				$listing = $listing . "\n$surname, $official";
				$listing = $listing . "  \($dates2\)" if ($dates2 ne "");
				}
			$plusChar = "+";
			# Surround plus by spaces
			$nextline =~ s/^\+/ \+ /;
			$graveCount++;
			# print "PLUSSER!!\n";
			}
		
		# See if this is a missing marker site
		if ($nextline =~ /^\-.*/) {
			$missingChar = "-";
			# Remove leading -
			$nextline =~ s/^-//;
			# Decrement stonecount
			$stoneCount--;
			# print "MINUSER!!\n";
			}

		# Add all non-blank lines to buffer 
		if ($nextline =~ /\w/) {
			# Remove CR/NL chars
			$nextline =~ s/\n/ /g;
			$nextline =~ s/\r/ /g;
			# print "###Adding: $nextline\n";
			$paragraph .= $nextline;
			$dates1 = $dates2 = "";
			}
	}
}
print "Total of $row Rows, $stoneCount markers, $graveCount burials\n";
