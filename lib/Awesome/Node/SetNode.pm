package Awesome::Node::SetNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has symbol => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has value => (
    is       => 'ro',
    isa      => 'Awesome::Node',
    required => 1,
);

sub BUILDARGS {
    my ($self, $symbol, $value) = @_;
    return { symbol => $symbol, value => $value };
}

no Mouse;

sub equal {
    my ($self, $node) = @_;

    return 0 unless $self->symbol eq $node->symbol;
    return 0 unless $self->value->equal($node->value);
    return 1;
}

1;
