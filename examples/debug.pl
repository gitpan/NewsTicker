#!/bin/perl
$|++;
use strict;

use NewsTicker;
use Data::Dumper;

my $t = NewsTicker::Interface::HTML->new();
$t->addSource('http://localhost/cgi-bin/bofh.pl');
$t->addSource('/tmp/test.rdf');
$t->getmessages;
#print Dumper($t);
#$t->scroll;
print Dumper($t);
#print $t->allononepage;

