package NewsTicker::RDF;

use XML::Parser::Lite;
use Data::Dumper;
$|++;

sub new {
    my $class = shift;
    my $self = {source=>shift,objs=>[],channels=>[]};
    bless $self => $class;
}

sub parse {
    my $self = shift;
    my $data = shift;
    my $p = new XML::Parser::Lite;
    $self->setHandlers($p);
    $p->parse($data);
    $self->{objects} = $self->pakObjects(0);
    $self->handleData;
    $self->{source}->addChannel(@{$self->{channels}});
}

sub addChannel {
    my $self = shift;
    my $c = shift;
    my $channel = NewsTicker::Channel->new;
    foreach my $ch (@{$c->{children}}) {
        $channel->{$ch->{class}}=$ch->{data};
    }
    push @{$self->{channels}},$channel;
}
    
sub setHandlers {
    my $self = shift;
    my $p = shift;
    $p->setHandlers(
           Start => sub { shift; $self->start(@_) },
           Char => sub { shift; $self->char(@_)},
           End => sub { shift; $self->end(@_)},
    );
}

sub start {
    my $self = shift;
    my $tag = shift;
    push @{$self->{objs}}, {type => 'start', data => $tag};
}

sub char {
    my $self = shift;
    my $char = shift;
    chomp($char);
    #if ($char !~ /^\s*$/) {
        push @{$self->{objs}}, {type => 'char', data => $char};
    #}
}

sub end {
    my $self = shift;
    my $tag = shift;
    push @{$self->{objs}}, {type => 'end', data => $tag};
}

sub pakObjects { 
    my $self = shift;
    my $level = shift;
    while ($self->{objs}[0]{type} eq 'start') {
        my $object = {class => (shift(@{$self->{objs}}))->{data},children=>[]};
        if ($self->{objs}[0]{type} eq 'char') {
            $object->{data} = (shift(@{$self->{objs}}))->{data};
        }
        while ($self->{objs}[0]{type} eq 'start') {
            push @{$object->{children}}, $self->pakObjects($level+1);
        }
        if ($self->{objs}[0]{type} eq 'end') {
            shift(@{$self->{objs}}); # end shiften
            shift(@{$self->{objs}}); # lege char na end shiften
        }
        return $object;
    }
}

sub channel {
    my $self = shift;
    return $self->{channels}[-1];
}

sub addItem {
    my $self = shift;
    my $i = shift;
    my $m = NewsTicker::Message->new;
    foreach my $a (@{$i->{children}}) {
        if ($a->{class} eq 'title') {
            $m->{title} = $a->{data};
        }
        elsif ($a->{class} eq 'link') {
            $m->{'link'} = $a->{data};
        }
    }
    $self->channel->addMessage($m);
}

sub handleData {
    my $self = shift;
    my $rdf = $self->{objects};
    if ($rdf->{class} eq 'rdf:RDF') {
        my $i=1;
        my @objecten = @{$rdf->{children}};
        foreach my $child (@objecten) {
            if ($child->{class} eq 'channel') {
                $self->addChannel($child);
                # $self->channel is nu het huidige channel...
            }
            elsif ($child->{class} eq 'image') {
                # fuck it, toch nog geen X-interface
                next;
            }
            elsif ($child->{class} eq 'item') {
                $self->addItem($child);
            }
        }
    }
    else {
        return;
    }
    #undef $self->{objects};
}
            
1;
