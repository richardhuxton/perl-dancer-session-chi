use warnings;
use strict;
use Test::More;

use Dancer::Config 'setting';
use Dancer::Session;
use Dancer::Session::CHI;

setting 'session'     => 'CHI';
setting 'session_driver' => 'Memory';
setting 'session_params' => { global => 1 };

my $dsc = Dancer::Session::CHI->new();
my $session_cache = Dancer::Session::CHI::cache();

ok( $session_cache, "Session cache set" );
$session_cache->set('key1', 'val1');
is( $session_cache->get('key1'), 'val1', "Session cache is working" );
$session_cache->set('key1', 'val2');
is( $session_cache->get('key1'), 'val2', "Session cache updated ok" );

done_testing;
exit;

