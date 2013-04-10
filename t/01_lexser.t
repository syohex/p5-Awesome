use strict;
use warnings;
use Test::More;

use Awesome::Lexer;

subtest 'test number' => sub {
    my @got = Awesome::Lexer->new->tokenize("1");
    my $expected = [["NUMBER", 1]];
    is_deeply(\@got, $expected);
};

subtest 'test string' => sub {
    my @got = Awesome::Lexer->new->tokenize('"hi"');
    my $expected = [["STRING", "hi"]];
    is_deeply(\@got, $expected);
};

subtest 'test identifier' => sub {
    my @got = Awesome::Lexer->new->tokenize('name');
    my $expected = [["IDENTIFIER", "name"]];
    is_deeply(\@got, $expected);
};

subtest 'test constant' => sub {
    my @got = Awesome::Lexer->new->tokenize('Name');
    my $expected = [["CONSTANT", "Name"]];
    is_deeply(\@got, $expected);
};

subtest 'test operator' => sub {
    my @got = Awesome::Lexer->new->tokenize('+');
    my $expected = [['+', '+']];
    is_deeply(\@got, $expected);

    @got = Awesome::Lexer->new->tokenize('||');
    $expected = [['||', '||']];
    is_deeply(\@got, $expected);
};

subtest 'test indent' => sub {
    my $code = <<'CODE';
if 1:
  if 2:
    print "..."
    if false:
      pass
    print "done!"
  2

print "The End"
CODE

    my @got = Awesome::Lexer->new->tokenize($code);
    my $expected = [
      ["IF", "if"], ["NUMBER", 1],
        ["INDENT", 2],
          ["IF", "if"], ["NUMBER", 2],
          ["INDENT", 4],
            ["IDENTIFIER", "print"], ["STRING", "..."], ["NEWLINE", "\n"],
            ["IF", "if"], ["FALSE", "false"],
            ["INDENT", 6],
              ["IDENTIFIER", "pass"],
            ["DEDENT", 4], ["NEWLINE", "\n"],
            ["IDENTIFIER", "print"], ["STRING", "done!"],
        ["DEDENT", 2], ["NEWLINE", "\n"],
        ["NUMBER", 2],
      ["DEDENT", 0], ["NEWLINE", "\n"],
      ["NEWLINE", "\n"],
      ["IDENTIFIER", "print"], ["STRING", "The End"]
    ];

    is_deeply(\@got, $expected);
};

subtest 'test bracket lexer' => sub {
    my $code = <<'CODE';
if 1 {
  print "..."
  if false {
    pass
  }
  print "done!"
}
print "The End"
CODE

    my @got = Awesome::Lexer->new->tokenize($code);
    my $expected = [
      ["IF", "if"], ["NUMBER", 1],
      ["{", "{"], ["NEWLINE", "\n"],
        ["IDENTIFIER", "print"], ["STRING", "..."], ["NEWLINE", "\n"],
        ["IF", "if"], ["FALSE", "false"], ["{", "{"], ["NEWLINE", "\n"],
          ["IDENTIFIER", "pass"], ["NEWLINE", "\n"],
        ["}", "}"], ["NEWLINE", "\n"],
        ["IDENTIFIER", "print"], ["STRING", "done!"], ["NEWLINE", "\n"],
      ["}", "}"], ["NEWLINE", "\n"],
      ["IDENTIFIER", "print"], ["STRING", "The End"]
    ];

    is_deeply(\@got, $expected);
};


done_testing;

__DATA__
require "test_helper"
require "lexer"

class LexerTest < Test::Unit::TestCase

  ## Exercise: Modify the lexer to delimit blocks with <code>{ ... }</code> instead of indentation.
  def test_braket_lexer
    require "bracket_lexer"

    code = <<-CODE
if 1 {
  print "..."
  if false {
    pass
  }
  print "done!"
}
print "The End"
CODE

    tokens = [
      [:IF, "if"], [:NUMBER, 1],
      ["{", "{"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "print"], [:STRING, "..."], [:NEWLINE, "\n"],
        [:IF, "if"], [:FALSE, "false"], ["{", "{"], [:NEWLINE, "\n"],
          [:IDENTIFIER, "pass"], [:NEWLINE, "\n"],
        ["}", "}"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "print"], [:STRING, "done!"], [:NEWLINE, "\n"],
      ["}", "}"], [:NEWLINE, "\n"],
      [:IDENTIFIER, "print"], [:STRING, "The End"]
    ]
    assert_equal tokens, BracketLexer.new.tokenize(code)
  end
end
