package NewsTicker::Message;

sub new {
    my $class = shift;
    my $self = {data=>shift};
    bless $self => $class;
}

sub title {
    my $self = shift;
    return $self->{title};
}

sub link {
    my $self = shift;
    return $self->{'link'};
}

1;
