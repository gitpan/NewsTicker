package NewsTicker::Interface::Console;

use strict;
use Term::ANSIScreen qw/:color :cursor :screen :keyboard/;
use Term::Size;
use Time::HiRes qw/usleep/;

push @NewsTicker::Interface::Console::ISA, qw/NewsTicker::Interface/;

sub scrollverticalsimple {
    my $self = shift;
    while (1) {
        foreach my $m ($self->getAllMessages) {
            print $m->title."\n";
            sleep 1;
        }
    }
}
sub colori {
    return "";
}

sub _makeString {
    my $self = shift;
    my $string;
    foreach my $source ($self->sources) {
        $string .= colori('red').$source->src.colori('reset')." ";
        foreach my $chan ($source->channels) {
            $string .= colori('green')."/[".$chan->title."]\\".colori('reset')." ";
            foreach my $mes ($chan->messages) {
                $string .= colori('yellow')."  _".$mes->title."_  ".colori('reset')." ";
            }
        }
    }
    return $string;#join("-",map {$_->title} $self->getAllMessages);
}

sub scrollhorizontal {
    my $self = shift;
    my $string = $self->_makeString;
    #my $raw = strip($string);
    my ($x, $y) = Term::Size::chars *STDOUT{IO};
    my $o = 0;
    for (my$i=1;$i<=length($string);$i++) {
        print savepos;
        my $len = ($o < $x) ? $o : $x;
        {
            my $s;
            if ($o < $x) { $s = 0 } else { $s = $i }
            print locate(1,$x-$o), randomize(substr($string,$s,$len));
        }
        print loadpos;
        usleep(180000);
        if ($o < $x) {
            $o++;
        }
    }
    print color('reset');
}

sub strip {
    my $str = shift;
    my $r;
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
    #print "verwijderd: $r\n";
    return $str;
}

sub randomcolor {
    my @clrs = qw/yellow red cyan blue green white/;
    return color($clrs[int(rand(@clrs))]);
}

sub randomize {
    my $tr = shift;
    my $str;
    for(my$i=0;$i<length($tr);$i++){
        $str .= randomcolor.substr($tr,$i,1).randomcolor;
    }
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

1;
