#!/bin/perl
$|++;
use strict;

use Term::ANSIScreen qw/:color :cursor :screen :keyboard/;
use Term::Size;
use Time::HiRes qw/usleep/;

sub scrollhorizontal {
    my $string = "jaap is een lul ... "x100;
    #my $raw = strip($string);
    my ($x, $y) = Term::Size::chars *STDOUT{IO};
    my $o = 0;
    for (my$i=1;$i<=length($string);$i++) {
        my (@pos) = savepos;
        my $len = ($o < $x) ? $o : $x;
        print locate(1,1),substr($string,$i,$len);
        print loadpos(@pos);
        usleep(180000);
        if ($o < $x) {
            $o++;
        }
    }
}
print "dus\n";
&scrollhorizontal;
