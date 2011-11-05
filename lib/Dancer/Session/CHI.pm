package Dancer::Session::CHI;

use strict;
use warnings;
use base 'Dancer::Session::Abstract';

use Dancer::ModuleLoader;
use Dancer::Config 'setting';

use version 0.77; our $VERSION = qv('0.01');

# Package-wide cache
my $cache;
my %options;


# ordinary subs

sub cache {
    return $cache ||= _build_cache($options{params});
}

# _call_via(subname)
#   Checks that subname is something like Foo::Bar::provide_cache and then
#   calls it.
#
sub _call_via {
    my $via = shift;
    my $res;

    unless ($via =~ qr{\A [A-Z_a-z] [0-9A-Z_a-z]* (?: :: [0-9A-Z_a-z]+)* \z}x) {
        die "_call_via only accepts ASCII identifiers and ::";
    }

    eval {
        no strict 'refs';
        $res = &$via($options{params});
    };
    die "Failed to call $via: $@" if $@;
    return $res;
}

sub _build_cache {
    if ($options{via}) {
        $cache = _call_via($options{via})
            || die "Failed to read cache via $options{via}";
        #Dancer::debug(__PACKAGE__." sharing cache from {$options{via}}");
    }
    elsif ($options{driver}) {
        $cache = CHI->new( driver => $options{driver}, %{$options{params}} )
            or die "failed to create CHI cache";
        #Dancer::debug(__PACKAGE__." created cache with driver $options{driver}");
    }
    else {
        die "No via/driver option for the CHI session";
    }
}

# class methods

sub init {
    my ($class) = @_;

    $class->SUPER::init(@_);

    die "CHI is needed and is not installed"
      unless Dancer::ModuleLoader->load('CHI');

 	# require either a driver or "via" in settings
    my $via    = setting('session_via');
	my $driver = setting('session_driver');
	my $params = setting('session_params') || {};
    die "You must specify session_via or session_driver for CHI sessions"
        unless ($driver || $params);

	unless ($params->{namespace}) {
		$params->{namespace} = __PACKAGE__;
	}

    %options = (
        via    => $via,
        driver => $driver,
        params => $params
    );
}

# create and return a new session object
sub create {
    my ($class) = @_;

    my $self = Dancer::Session::CHI->new;
    $self->flush;
    return $self;
}

# Return the session object corresponding to the given id
sub retrieve {
    my ($class, $id) = @_;

	return cache->get($id);
}

# instance methods

sub destroy {
    my ($self) = @_;
	cache->remove($self->id);
}

sub flush {
    my $self = shift;
	cache->set($self->id, $self);
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

The Dancer setting B<session> should be set to C<CHI>.

You should specify a C<session_driver> and if that driver needs parameters,
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

or, to share via a sub that returns an already-built CHI object reference:

    session: CHI
    session_via: "Dancer::Plugin::Cache::CHI::cache"
    session_params:
        these: "get passed to cache()"

Finally, you might want to set in session_params a C<namespace> for the
case when you have multiple apps sharing the same cache. Session IDs might
collide in this case. See the L<CHI> documentation for details. If unset it
defaults to "Dancer::Session::CHI".

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
