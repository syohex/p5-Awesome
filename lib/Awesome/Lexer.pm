package Awesome::Lexer;
use strict;
use warnings;

my @KEYWORDS = qw(def class if else while true false nil);

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub tokenize {
    my ($self, $code) = @_;

    # Cleanup code by remote extra line breaks
    chomp($code);

    # Current character position we're parsing
    my $i = 0;

    # Collection of all parsed tokens in the form [:TOKEN_TYPE, value]
    my @tokens;

    # Current indent level is the number of spaces in the last ident
    my $current_indent = 0;

    # We keep track of the indentation levels we are in so that
    # when we dedent, we can check if we're on the correct level
    my @indent_stack;

    my @curly_brace_stack;

    # This is now to implement a very simple scanner
    # Scan one character at the time until you find something to parse

    while ($i < length $code) {
        my $chunk = substr $code, $i;

        # Matching standard tokens
        #
        if ($chunk =~ m{\A([a-z]\w*)}) {
            # Matching if, print, method names, etc
            my $identifier = $1;

            if (grep { $identifier eq $_ } @KEYWORDS) {
                push @tokens, [uc $identifier, $identifier];
            } else {
                push @tokens, ["IDENTIFIER", $identifier];
            }

            $i += length $identifier;
        } elsif ($chunk =~ m{\A([A-Z]\w*)}) {
            # Matching class names and constants starting with a capital letter
            my $constant = $1;
            push @tokens, ["CONSTANT", $constant];

            $i += length $constant;
        } elsif ($chunk =~ m{\A([0-9]+)}) {
            my $number = $1;
            push @tokens, ["NUMBER", $number];
            $i += length $number;
        } elsif ($chunk =~ m{\A"(.*?)"}) {
            my $string = $1;
            push @tokens, ["STRING", $string];

            $i += length($string) + 2;
        } elsif ($chunk =~ m{\A:\n( +)}m) { # Matches ": <newline> <spaces>"
            # Here's the indentation magic
            #
            # We have to take care of 3 cases
            #
            # if true   # 1) the block is created
            #    line 1
            #    line 2 # 2) new line inside a block
            # continue  # 3) dedent
            #
            # This elsif takes care of first case. The number of spaces will
            # determine the indent level

            my $indent = $1;
            my $indent_size = length $indent;

            if (length $indent <= $current_indent) {
                die "Bad indent level, got $indent_size indents",
                    "expected > $current_indent";
            }

            # Adjust the current indentation level
            $current_indent = $indent_size;
            push @indent_stack, $current_indent;

            push @tokens, ["INDENT", $indent_size];
            $i += $indent_size + 2; # '+2' is ':' and <newline>
        } elsif ($chunk =~ m/\A\{/m) {
            # Delimit with curly brace
            push @curly_brace_stack, "{";

            push @tokens, ["{", "{"];
            $i += 1;
        } elsif ($chunk =~ m/\A(\})/) {
            unless ($curly_brace_stack[-1] eq "{") {
                die "Invalid Curly brace";
            }
            pop @curly_brace_stack;

            push @tokens, ["}", "}"];
            $i += 1;
        } elsif ($chunk =~ m{\A\n( *)}m) { # Matches "<newline> <spaces>"

            # This elsif takes care of the two last cases
            # Case 2: we stay in the same block if the indent level
            #         (number of spaces) is the same as current_indent
            # Case 3: Close the current block, if indent level is lower
            #         than current_level

            my $indent = $1;
            my $indent_size = length $indent;

            if ($indent_size == $current_indent) { # Case 2
                # Nothing to do, we're still in the same block
                push @tokens, ["NEWLINE", "\n"];
            } elsif ($indent_size < $current_indent) { # Case 3
                while ($indent_size < $current_indent) {
                    pop @indent_stack;
                    $current_indent = $indent_stack[-1] || 0;
                    push @tokens, ["DEDENT", $indent_size];
                }
                push @tokens, ["NEWLINE", "\n"];
            } elsif (@curly_brace_stack) {
                push @tokens, ["NEWLINE", "\n"];
            } else { # indent size > current_indent Error!!
                # Cannot increase indent level without using ":", so this is error
                die "Missing ':'";
            }

            $i += $indent_size + 1; # '+1' is <newline>
        } elsif ($chunk =~ m{\A(\|\||&&|==|!=|<=|>=)}) {
            # Match long operators such as ||, &&, ==, !=, <= and >=
            my $operator = $1;

            push @tokens, [$operator, $operator];
            $i += length $operator;
        } elsif ($chunk =~ m{\A }) {
            # Ignore whitespace
            $i += 1;
        } else {
            # Catch all single characters
            # We treat all other single characters as a token. # ( ) , . ! + - <
            my $value = substr $chunk, 0, 1;
            push @tokens, [$value, $value];

            $i += 1;
        }
    }

    # close all open blocks
    while (my $indent = pop @indent_stack) {
        push @tokens, ["DEDENT", $indent_stack[0] || 0];
    }

    return @tokens;
}

1;

__END__
