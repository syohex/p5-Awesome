package Awesome::Node::CallNode;
use Mouse;

extends 'Awesome::Node';
with 'Awesome::Role::Comparable';

has invocant => (
    is       => 'ro',
    isa      => 'Maybe[Awesome::Node]',
);

has method => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has arglist => (
    is      => 'ro',
    isa     => 'ArrayRef[Awesome::Node]',
    default => sub { +[] },
);

sub BUILDARGS {
    my ($self, $invocant, $method, $arglist) = @_;
    return { invocant => $invocant, method => $method, arglist => $arglist };
}

no Mouse;

sub equal {
    my ($self, $node) = @_;

    if (defined $self->invocant) {
        return 0 unless defined $node->invocant;
        return 0 unless $self->invocant->equal($node->invocant);
    } else {
        return 0 if defined $node->invocant;
    }

    return 0 unless $self->method eq $node->method;

    unless (scalar @{$self->arglist} == scalar @{$self->arglist}) {
        return 0;
    }

    for my $i (0..(scalar @{$self->arglist} - 1)) {
        unless ($self->arglist->[$i]->equal($node->arglist->[$i])) {
            return 0
        }
    }

    return 1;
}

1;
