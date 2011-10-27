use warnings;
use strict;
use Test::More;

use Dancer::Session;
use Dancer::Config 'setting';
use Dancer::Session::CHI;

setting 'session'     => 'CHI';
setting 'session_via' => 'Foo::Bar::cache';

{
    package Foo::Bar;

    our $num_calls = 0;
    our $test_val  = { a => 'b' };

    sub cache {
        $num_calls++;
        return $test_val;
    }

    1;
}

use Dancer::Session::CHI;
my $dsc = Dancer::Session::CHI->new();

my $session_cache = Dancer::Session::CHI::cache();

is( $Foo::Bar::num_calls, 1, "'via' called once" );
is_deeply( $session_cache, $Foo::Bar::test_val, "Cache as expected - 1" );

$session_cache->{c} = 'd';
$session_cache = Dancer::Session::CHI::cache();
is( $Foo::Bar::num_calls, 1, "'via' called once" );
is_deeply( $session_cache, $Foo::Bar::test_val, "Cache as expected - 2" );
is_deeply( $Foo::Bar::test_val, {a=>'b',c=>'d'}, "Cache is shared" );

done_testing;
exit;
