package NewsTicker::Channel;

use strict;

sub new {
    my $class = shift;
    my $self = {messages=>[]};
    bless $self => $class;
}

sub addMessage {
    my $self = shift;
    my $msg = shift;
    if ($msg) {
        push @{$self->{messages}}, $msg;
    }
}

sub getAllMessages {
    my $self = shift;
    return @{$self->{messages}};
}

sub title {
    my $self = shift;
    if (@_) {
        $self->{title} = shift;
    }
    if (wantarray) {
        return $self->{title};
    }
}

sub messages {
    my $self = shift;
    return $self->getAllMessages;
}
1;
