#!/bin/perl

use Term::ANSIScreen qw/:color/;
my $st = color('red')."hallo dan".color('yellow')." daarzo".color('reset');

sub strip {
    my $str = shift;
    my $r=0;
    for(my$i=0;$i<length($str);$i++) {
        my $c=substr($str,$i,1);
        if (ord($c) == 27) {
            substr($str,$i,1,"");
            # pak er eens tien
            my $lul = substr($str,$i,10);
            #print "zoek hierin: $lul\n";
            $lul =~ s/^(\[\d*m)//;
            $r += length($1+1);
            #print "dit over: $lul\n";
            # en eroverheen:)
            substr($str,$i,10,$lul);
            $i -= length($1);
        }
    }
    print "verwijderd: $r\n";
    return $str;
}

sub substring {
    my $str = strip(shift);
    return substr($str,@_);
}

sub lengte {
    my $str = strip(shift);
    return length($str);
}

foreach my $str ($st,strip($st)) {
    print $str."\n";
    print "lengte: ".length($str).", echte lengte: ".lengte($str)."\n";
}
