package NewsTicker::Interface::HTML;

push @NewsTicker::Interface::HTML::ISA,qw/NewsTicker::Interface/;
use Template;

sub allononepage {
    my $self = shift;
    return $self->template('allononepage.html',{ticker=>$self});
}

sub template {
    my $self = shift;
    my ($name,$data,$out) = (@_,'');
    Template->new(INCLUDE_PATH => '/var/www/templates/newsticker')->process($name,$data,\$out) or die Template->error;
    return $out;
}

1;
