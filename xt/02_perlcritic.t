use strict;
use Test::More;
eval q{
    use Test::Perl::Critic 1.02 -exclude => [
        'Subroutines::ProhibitSubroutinePrototypes',
        'Subroutines::ProhibitExplicitReturnUndef',
        'TestingAndDebugging::ProhibitNoStrict',
        'ControlStructures::ProhibitMutatingListFunctions',
        'InputOutput::RequireEncodingWithUTF8Layer',
    ]
};
plan skip_all => "Test::Perl::Critic 1.02+ is not installed." if $@;

critic_ok('lib/Awesome.pm');
critic_ok('lib/Awesome/Lexer.pm');

done_testing;
