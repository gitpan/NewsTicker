package NewsTicker::Interface;

push @NewsTicker::Interface::ISA,qw/NewsTicker/;
use strict;

sub new {
    my $class = shift;
    my $self = NewsTicker->new;
    bless $self => $class;
}

sub getmessages {
    my $self = shift;
    $self->_getAllMessages;
}

sub detectclass {
    my $self = shift;
    my $type = shift;
    if ($type eq 'html') {
        return 'NewsTicker::Interface::HTML';
    }
    elsif ($type eq 'console') {
        return 'NewsTicker::Interface::HTML';
    }
}
    

1;

