package NewsTicker::Source;

sub new {
    my $class = shift;
    my $self = {src=>shift,channels=>[]};
    $self->{parser}=NewsTicker::RDF->new($self);
    if ($self->{src} =~ /^http:\/\//) {
        bless $self => 'NewsTicker::Source::HTTP';
    }
    elsif (-f $self->{src}) {
        if (-x $self->{src}) {
            bless $self => 'NewsTicker::Source::Program';
        }
        else {
            bless $self => 'NewsTicker::Source::File';
        }
    }
    else {
        bless $self => $class;
    }
    return $self;
}

sub getXML {
    my $self = shift;
    return;
}

sub getMessages {
    my $self = shift;
    my $xml = $self->getXML;
    if (defined $xml) {
        $self->{parser}->parse($xml);
        my @messages;
        foreach my $channel (@{$self->{channels}}) {
            push @messages, $channel->getAllMessages;
        }
        return @messages;
    }
    return ();
}

sub addChannel {
    my $self = shift;
    push @{$self->{channels}},@_;
}

sub channels {
    my $self = shift;
    return @{$self->{channels}};
}

sub src {
    my $self = shift;
    return $self->{src};
}

1;

