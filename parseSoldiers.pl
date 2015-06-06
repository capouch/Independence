#!/usr/bin/perl

while ($nextline = <STDIN>) {

	# Chop leading whitespace
	for ($nextline) {
		s/^\s+//;
		}
next if $nextline eq "\n";
	#print "Here is $nextline";
	($unit, $rest,$renssy) = split("\t",$nextline);
	print "Name: $rest\nUnit:$unit\n";
	# print "Ren: $renssy\n";
	}
