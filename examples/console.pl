#!/usr/bin/perl
$|++;
use strict;
use NewsTicker;

my $t = NewsTicker::Interface::Console->new();
$t->addSource('http://slashdot.org/slashdot.rdf');
while (1) {
	$t->getmessages;
	$t->scrollhorizontal;
}
