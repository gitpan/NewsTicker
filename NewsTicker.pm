package NewsTicker;

use strict;

use NewsTicker::Source;
use NewsTicker::Channel;
use NewsTicker::RDF;
use NewsTicker::Source::HTTP;
use NewsTicker::Source::File;
use NewsTicker::Message;
use NewsTicker::Interface;
use NewsTicker::Interface::Console;
use NewsTicker::Interface::HTML;

sub new {
    my $class = shift;
    my $self = {sources=>[]};
    bless $self => $class;
}

sub sources {
    my $self = shift;
    return @{$self->{sources}};
}

sub addSource {
    my $self = shift;
    my $src = shift;
    if ($src) {
        push @{$self->{sources}}, NewsTicker::Source->new($src);
    }
}

sub _getAllMessages {
    my $self = shift;
    foreach my $src ($self->sources) {
        $src->getMessages;
    }
}

sub getAllMessages {
    my $self = shift;
    $self->_getAllMessages;
    my @m;
    foreach my $src ($self->sources) {
        push @m, $src->getMessages;
    }
    return @m;
    
}
1;
