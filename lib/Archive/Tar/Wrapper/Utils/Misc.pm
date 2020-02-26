package Archive::Tar::Wrapper::Utils::Misc;
use warnings;
use strict;
use Exporter 'import';

our $VERSION = '0.38';
our @EXPORT_OK = qw(is_gnu find_tar);

use constant SPACE => qr/s/;
use constant GNU   => qr/GNU/;

sub is_gnu {
    my $tar_path = shift;

    # double quoting is required on Windows if there are spaces in the path
    $tar_path = qq{$tar_path} if ( $tar_path =~ SPACE );
    my $version_info = `$tar_path --version`;

    if ( $version_info =~ GNU ) {
        return 1;
    }

    return 0;

}

sub find_tar {
    my @options = @_;
    my $tar_path = undef;

    foreach my $option (@options) {
        $tar_path = which($option);
        last if ( defined($tar_path) );
    }

    return $tar_path;
}

1;
