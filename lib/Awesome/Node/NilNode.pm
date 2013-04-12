package Awesome::Node::NilNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has value => (
    is      => 'ro',
    isa     => 'Str',
    default => 'nil',
);

no Mouse;

sub equal {
    my ($self, $node) = @_;
    return $self->value eq 'nil' && $node->value eq 'nil';
}

1;
