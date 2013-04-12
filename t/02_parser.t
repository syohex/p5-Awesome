use strict;
use warnings;
use Test::More;

use Awesome::Parser;

subtest 'number' => sub {
    my $got = Awesome::Parser->new->parse("1");
    my $expected = Awesome::Node::NumberNode->new(1);

    ok $got->nth(0)->equal($expected);
};

subtest 'expression' => sub {
    my $got = Awesome::Parser->new->parse(qq{1\n"hi"});
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::NumberNode->new(1),
        Awesome::Node::StringNode->new("hi"),
    );

    ok $got->equal($expected);
};

subtest 'method call' => sub {
    my $got = Awesome::Parser->new->parse(qq{1.method});
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::CallNode->new(
            Awesome::Node::NumberNode->new(1),
            "method",
            [],
        ),
    );

    ok $got->equal($expected);
};

subtest 'call with arguments' => sub {
    my $got = Awesome::Parser->new->parse(qq{method(1, 2)});
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::CallNode->new(undef, "method", [
            Awesome::Node::NumberNode->new(1),
            Awesome::Node::NumberNode->new(2),
        ]),
    );

    ok $got->equal($expected);
};

subtest 'local assign' => sub {
    my $got = Awesome::Parser->new->parse(qq{a = 1});
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::SetLocalNode->new("a", Awesome::Node::NumberNode->new(1)),
    );

    ok $got->equal($expected);
};

subtest 'constant assign' => sub {
    my $got = Awesome::Parser->new->parse(qq{A = 1});
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::SetConstantNode->new("A", Awesome::Node::NumberNode->new(1)),
    );

    ok $got->equal($expected);
};

subtest 'def(define function)' => sub {
    my $code = <<'...';
def method:
  true
...

    my $got = Awesome::Parser->new->parse($code);
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::DefNode->new(
            "method",
            [],
            Awesome::Node::Nodes->new(
                Awesome::Node::TrueNode->new,
            ),
        ),
    );

    ok $got->equal($expected);
};

subtest 'def with param' => sub {
    my $code = <<'...';
def method(a, b):
  true
...

    my $got = Awesome::Parser->new->parse($code);
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::DefNode->new(
            "method",
            ["a", "b"],
            Awesome::Node::Nodes->new(
                Awesome::Node::TrueNode->new,
            ),
        ),
    );

    ok $got->equal($expected);
};

subtest 'class' => sub {
    my $code = <<'...';
class Muffin:
  true
...

    my $got = Awesome::Parser->new->parse($code);
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::ClassNode->new(
            "Muffin",
            Awesome::Node::Nodes->new(
                Awesome::Node::TrueNode->new,
            ),
        ),
    );

    ok $got->equal($expected);
};

subtest 'arithmetic' => sub {
    my $got = Awesome::Parser->new->parse("1 + 2 * 3");
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::CallNode->new(
            Awesome::Node::NumberNode->new(1),
            "+",
            [
                Awesome::Node::CallNode->new(
                    Awesome::Node::NumberNode->new(2),
                    "*",
                    [Awesome::Node::NumberNode->new(3)],
                ),
            ],
        ),
    );

    ok $got->equal($expected);
};

subtest 'binary operator' => sub {
    my $got = Awesome::Parser->new->parse("1 + 2 || 3");
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::CallNode->new(
            Awesome::Node::CallNode->new(
                Awesome::Node::NumberNode->new(1),
                "+",
                [Awesome::Node::NumberNode->new(2)],
            ),
            "||",
            [Awesome::Node::NumberNode->new(3)]
        ),
    );

    ok $got->equal($expected);
};

subtest 'unary operator' => sub {
    my $got = Awesome::Parser->new->parse("!2");
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::CallNode->new(
            Awesome::Node::NumberNode->new(2),
            "!",
            []
        ),
    );
    ok $got->equal($expected);
};

subtest 'if test' => sub {
    my $code = <<'...';
if true:
  nil
...
    my $got = Awesome::Parser->new->parse($code);
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::IfNode->new(
            Awesome::Node::TrueNode->new,
            Awesome::Node::Nodes->new(
                Awesome::Node::NilNode->new,
            ),
        ),
    );

    ok $got->equal($expected);
};

subtest 'while test' => sub {
    my $code = <<'...';
while true:
  nil
...
    my $got = Awesome::Parser->new->parse($code);
    my $expected = Awesome::Node::Nodes->new(
        Awesome::Node::WhileNode->new(
            Awesome::Node::TrueNode->new,
            Awesome::Node::Nodes->new(
                Awesome::Node::NilNode->new,
            ),
        ),
    );

    ok $got->equal($expected);
};

done_testing;
