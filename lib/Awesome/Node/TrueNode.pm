package Awesome::Node::TrueNode;
use Mouse;

extends 'Awesome::Node::BoolNode';

has '+value' => (
    default => 'true',
);

1;
