package NewsTicker::Source::Program;

push @NewsTicker::Source::Program::ISA,qw/NewsTicker::Source/;
use IO::File;

sub getXML {
    my $self = shift;
    my $fh = new IO::File;
    if ($fh->open("< $self->{src}")) {
        my $xml;
        while (<$fh>) {
            $xml .= $_;
        }
        return $xml;
    }
    return;
}
1;


