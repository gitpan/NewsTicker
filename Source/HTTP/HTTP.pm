package NewsTicker::Source::HTTP;

push @NewsTicker::Source::HTTP::ISA,qw/NewsTicker::Source/;
use LWP::Simple;

sub getXML {
    my $self = shift;
    if (my $xml = get($self->{src})) {
        return $xml;
    }
    else {
        return;
    }
}
1;


