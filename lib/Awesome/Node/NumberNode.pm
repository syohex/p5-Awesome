package Awesome::Node::NumberNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has value => (
    is       => 'ro',
    isa      => 'Num',
    required => 1,
);

sub BUILDARGS {
    my ($self, $value) = @_;
    return { value => $value },
}

no Mouse;

use parent qw/Awesome::Node/;

sub equal {
    my ($self, $node) = @_;
    return $self->value == $node->value;
}

1;
