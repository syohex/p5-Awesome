package Awesome::Node::WhileNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has condition => (
    is       => 'ro',
    isa      => 'Awesome::Node',
    required => 1,
);

has body => (
    is       => 'ro',
    isa      => 'Awesome::Node::Nodes',
    required => 1,
);

sub BUILDARGS {
    my ($self, $condition, $body) = @_;
    return { condition => $condition, body => $body };
}

no Mouse;

sub equal {
    my ($self, $node) = @_;

    return 0 unless $self->condition->equal($node->condition);
    return 0 unless $self->body->equal($node->body);

    return 1;
}

1;
