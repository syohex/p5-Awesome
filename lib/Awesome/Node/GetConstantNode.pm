package Awesome::Node::GetConstant;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has symbol => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

no Mouse;

sub equal {
    my ($self, $node) = @_;
    return $self->symbol eq $node->symbol;
}

1;
