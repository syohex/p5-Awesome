package Awesome::Node::StringNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has value => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub BUILDARGS {
    my ($self, $value) = @_;
    return { value => $value};
}

no Mouse;

sub equal {
    my ($self, $node) = @_;
    return $self->value eq $node->value;
}

1;

__END__
