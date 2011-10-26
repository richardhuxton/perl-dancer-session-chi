package Dancer::Session::CHI;

use strict;
use warnings;
use base 'Dancer::Session::Abstract';
use vars qw($VERSION);

use Dancer::ModuleLoader;
use Dancer::Config 'setting';

$VERSION = '0.01';

# Package-wide cache
my $cache;


# static

sub init {
    my ($class) = @_;

    $class->SUPER::init(@_);

    die "CHI is needed and is not installed"
      unless Dancer::ModuleLoader->load('CHI');

 	# require a driver...
	my $driver = setting('session_driver')
		or die "session_driver must be set for CHI sessions";
	my $params = setting('session_params') || {};
	unless ($params->{namespace}) {
		$params->{namespace} = __PACKAGE__;
	}

	$cache = CHI->new( driver => $driver, %$params )
		or die "failed to create CHI cache";

    Dancer::Logger->debug("CHI session_driver : $driver");
}

# create a new session and return the newborn object
# representing that session
sub create {
    my ($class) = @_;

    my $self = Dancer::Session::CHI->new;
    $self->flush;
    return $self;
}

# Return the session object corresponding to the given id
sub retrieve {
    my ($class, $id) = @_;

	return $cache->get($id);
}

# instance

sub destroy {
    my ($self) = @_;
	$cache->remove($self->id);
}

sub flush {
    my $self = shift;
	$cache->set($self->id, $self);
    return $self;
}

1;
__END__

=pod

=head1 NAME

Dancer::Session::CHI - Sessions stored in a CHI-based cache

=head1 DESCRIPTION

This module implements a session engine by using the L<CHI> framework.
 
=head1 CONFIGURATION

The setting B<session> should be set to C<CHI>.

You need to specify a C<session_driver> and if that driver needs parameters,
then C<session_params> too.

Here is an example configuration:

    session: CHI
    session_driver: FastMmap
    session_params: { root_dir: '/path/to/cache', cache_size: '1m' }

Or perhaps:

    session: CHI
    session_driver: File
    session_params:
        root_dir: "/srv/testapp/cache/file"
        depth: 2
        expires_in: 3600

=head1 DEPENDENCY

This module depends on both L<Dancer> and L<CHI>.

=head1 AUTHOR

Richard Huxton <richard.huxton@gmail.com>

=head1 ACKNOWLEDGEMENTS

The structure of this module is mostly cut+paste work from David Precious'
L<Dancer::Session::Storable>.

=head1 SEE ALSO

See L<Dancer::Session> for details about session usage in route handlers, and
L<Dancer> for general information on the Dancer web framework.  See L<CHI>
for details on the CHI framework.

=head1 COPYRIGHT

This module is copyright (c) 2010-2011 David Precious <davidp@preshweb.co.uk>

=head1 LICENSE

This module is free software and is released under the same terms as Perl
itself.

=cut
