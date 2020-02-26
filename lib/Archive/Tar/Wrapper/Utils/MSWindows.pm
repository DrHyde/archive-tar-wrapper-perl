package Archive::Tar::Wrapper::Utils::MSWindows;
use warnings;
use strict;
use Exporter 'import';
use Archive::Tar::Wrapper::Utils::Misc qw(find_tar);

our $VERSION     = '0.38';
our @EXPORT_OK   = qw(is_valid_win find_win_tar);
our %EXPORT_TAGS = ( all => [qw(is_valid_win find_win_tar)] );

sub is_valid_win {
    my ( $product_info, $major, $minor, $id ) = @_;
    print "Running on $product_info - major=$major, minor=$minor, id=$id\n";

    unless ( $major >= 6 ) {
        warn
"Too old Microsoft Windows to be supported, major version must be equal or higher 6.\n";
        return 0;
    }

    unless ( defined( find_win_tar() ) ) {
        warn "No tar program available, cannot work without it.\n";
        return 0;
    }

    return 1;

}

sub find_win_tar {
    return find_tar( 'bsdtar.exe', 'tar.exe' );
}

1;
