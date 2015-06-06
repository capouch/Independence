#!/usr/bin/perl
$lastline = "";
while ($nextline = <STDIN>) {

#	if ($nextline eq "\n")
	if ($lastline eq "\n") {
	    if ($nextline eq "\n") {
	      next;
	      }
	  } 
	#print "Here is $nextline";
	print $nextline;
	$lastline = $nextline;
	# print "Ren: $renssy\n";
	}
