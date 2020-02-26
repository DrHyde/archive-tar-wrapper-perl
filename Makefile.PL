use warnings;
use strict;
use ExtUtils::MakeMaker;
use lib './lib';
use Archive::Tar::Wrapper::Utils::MSWindows qw(:all);
use Archive::Tar::Wrapper::Utils::Misc qw(is_gnu);

if ( $^O eq 'solaris' ) {
    die "OS unsupported\n";
}

if ( $^O eq 'MSWin32' ) {
    require Win32;
    my ( $osvername, $major, $minor, $id ) = Win32::GetOSVersion();
    die "OS unsupported\n"
      unless ( is_valid_win( Win32::GetOSDisplayName(), $major, $minor, $id ) );
    my $tar_path = find_win_tar();
    die "OS unsupported\n" unless ( defined($tar_path) );
    die "OS unsupported\n" if ( is_gnu($tar_path) );
}

my ( $module_path, $module_version );

{
    require ExtUtils::MY;
    my $version_reader = MM->new();
    $module_path    = 'lib/Archive/Tar/Wrapper.pm';
    $module_version = $version_reader->parse_version("./$module_path");
}

my %WriteMakefileArgs = (
    'NAME'             => 'Archive::Tar::Wrapper',
    'VERSION'          => $module_version,
    'MIN_PERL_VERSION' => 5.008001,
    'PREREQ_PM'        => {
        'File::Temp'    => 0,
        'Cwd'           => 0,
        'Log::Log4perl' => 0,
        'IPC::Run'      => 0,
        'File::Which'   => 0
    },
);

if ( $ExtUtils::MakeMaker::VERSION >= 6.46 ) {
    $WriteMakefileArgs{META_MERGE} = {
        provides => {
            'Archive::Tar::Wrapper' => {
                file    => $module_path,
                version => $module_version
            }
        }
    };
}

if ( $ExtUtils::MakeMaker::VERSION >= 6.50 ) {
    $WriteMakefileArgs{META_MERGE}->{'meta-spec'} = { version => 2 };
    $WriteMakefileArgs{META_MERGE}->{'resources'} = {
        'bugtracker' => {
            'web' =>
              'https://github.com/glasswalk3r/archive-tar-wrapper-perl/issues',
        },
        'repository' => {
            'type' => 'git',
            'url' =>
              'https://github.com/glasswalk3r/archive-tar-wrapper-perl.git',
            'web' => 'https://github.com/glasswalk3r/archive-tar-wrapper-perl',
        }
    };
}

# Test::More::is_deeply is required for testing
if ( $ExtUtils::MakeMaker::VERSION >= 6.64 ) {
    $WriteMakefileArgs{TEST_REQUIRES}->{'Test::Simple'} = 1.302073;
}
else {
    $WriteMakefileArgs{PREREQ_PM}->{'Test::Simple'} = 1.302073;
}

if ( $ExtUtils::MakeMaker::VERSION >= 6.52 ) {
    $WriteMakefileArgs{CONFIGURE_REQUIRES} = {
        'ExtUtils::MakeMaker' => 0,
        'File::Which'         => 0,
    };
}

if ( $] >= 5.005 ) {
    $WriteMakefileArgs{ABSTRACT_FROM} = 'lib/Archive/Tar/Wrapper.pm';
    $WriteMakefileArgs{AUTHOR}        = [
        'Mike Schilli <cpan@perlmeister.com>',
        'Alceu Rodrigues de Freitas Junior <arfreitas@cpan.org>'
    ];
}

$WriteMakefileArgs{LICENSE} = 'gpl_3'
  if ( $ExtUtils::MakeMaker::VERSION >= 6.3002 );
WriteMakefile(%WriteMakefileArgs);
