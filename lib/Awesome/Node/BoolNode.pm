package Awesome::Node::BoolNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has value => (
    is  => 'ro',
    isa => 'Str',
);

no Mouse;

sub equal {
    my ($self, $node) = @_;
    return $self->value eq $node->value;
}

1;
