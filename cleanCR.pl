#!/usr/bin/perl
while ($nextline = <STDIN>) {

	
	$nextline =~ s/\r//g;
	print $nextline;
	}
