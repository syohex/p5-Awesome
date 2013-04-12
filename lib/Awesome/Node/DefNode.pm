package Awesome::Node::DefNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has arglist => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { +[] },
);

has body => (
    is       => 'ro',
    isa      => 'Awesome::Node::Nodes',
    required => 1,
);

sub BUILDARGS {
    my ($self, $name, $arglist, $body) = @_;
    return { name => $name, arglist => $arglist, body => $body};
}

no Mouse;

sub equal {
    my ($self, $node) = @_;

    return 0 unless $self->name eq $node->name;

    unless (scalar @{$self->arglist} == scalar @{$node->arglist}) {
        for my $i (0..(scalar @{$self->arglist})) {
            my $argument = $self->arglist->[$i];
            return 0 unless $argument->equal($node->arglist->[$i]);
        }
    }

    return 0 unless $self->body->equal($node->body);

    return 1;
}

1;
