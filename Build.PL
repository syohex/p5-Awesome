use strict;
use warnings;
use Module::Build;
use File::Spec;

my $class = Module::Build->subclass(
    class => 'My::Builder',
    code  => <<'...'

sub ACTION_code {
    my $self = shift;
    my $yapp_files = $self->{properties}->{yapp_file};

    if (defined $yapp_files) {
        unless (ref $yapp_files eq "ARRAY") {
            $yapp_files = [$yapp_files];
        }

        for my $yapp_file (@{$yapp_files}) {
            my $relpath = _to_relative_path($yapp_file);
            (my $output_module = $relpath) =~ s{\.yp\z}{\.pm};
            my $parser_package = do {
                local $_ = $yapp_file;
                s{\Alib/}{};
                s{/}{::}g;
                s{\.yp\z}{};
                $_;
            };

            unless ($self->up_to_date($yapp_file, $output_module)) {
                my @args = ("-s", # Output stand alone module
                            "-m", $parser_package,
                            "-o", $output_module,
                            $yapp_file);
                $self->do_system("yapp", @args);
                $self->add_to_cleanup($output_module);
            }
        }
    }

    $self->SUPER::ACTION_code(@_);
}

sub _to_relative_path {
    my $file = shift;

    my $cpath = File::Spec->canonpath($file);
    if (File::Spec->file_name_is_absolute($cpath)) {
        return File::Spec->abs2rel($file);
    }

    return $file;
}
...
);

my $build = My::Builder->new(
    license              => 'perl',
    dynamic_config       => 0,

    build_requires       => {
        'Test::More'     => '0.98',
    },
    configure_requires   => {
        'Module::Build' => '0.38',
        'Parse::Yapp'   => '1.05',
    },
    requires => {
        'parent'        => 0,
    },

    no_index    => { 'directory' => [ 'inc' ] },
    name        => 'Awesome',
    module_name => 'Awesome',

    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,

    yapp_file => ['lib/Awesome/Parser.yp'],

    create_readme  => 0,
    create_license => 0,
);

$build->create_build_script();
