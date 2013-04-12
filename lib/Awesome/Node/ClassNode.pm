package Awesome::Node::ClassNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has body => (
    is   => 'ro',
    isa  => 'Awesome::Node::Nodes',
    required => 1,
);

sub BUILDARGS {
    my ($self, $name, $body) = @_;
    return { name => $name, body => $body };
}

no Mouse;

sub equal {
    my ($self, $node) = @_;

    return 0 unless $self->name eq $node->name;
    return 0 unless $self->body->equal($node->body);

    return 1;
}

1;
