package Awesome::Node::Nodes;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has nodes => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

sub BUILDARGS {
    my ($self, @args) = @_;
    return { nodes => [@args] };
}

no Mouse;

sub push_node {
    my ($self, $node) = @_;
    push @{$self->nodes}, $node;

    return $self;
}

sub nth {
    my ($self, $index) = @_;
    return $self->nodes->[$index];
}

sub equal {
    my ($self, $nodes) = @_;

    unless (scalar @{$self->nodes} == scalar @{$nodes->nodes}) {
        return 0;
    }

    for my $i (0..(scalar @{$self->nodes} - 1)) {
        my ($a, $b) = ($self->nodes->[$i], $nodes->nodes->[$i]);

        my ($a_blessed, $b_blessed) = (blessed $a, blessed $b);
        return 0 unless defined $a_blessed && defined $b_blessed;
        return 0 unless $a_blessed eq $b_blessed;

        return 0 unless $a->equal($b);
    }

    return 1;
}

1;
