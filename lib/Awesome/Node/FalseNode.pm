package Awesome::Node::FalseNode;
use Mouse;

extends 'Awesome::Node::BoolNode';

has '+value' => (
    default => "false",
);

1;
