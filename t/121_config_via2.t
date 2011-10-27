use warnings;
use strict;
use Test::More;

use Dancer::Config 'setting';
use Dancer::Session::CHI;
use Dancer::Plugin::Cache::CHI;

setting 'session'     => 'CHI';
setting 'session_via' => 'Dancer::Plugin::Cache::CHI::cache';
setting 'plugins' => {
    'Cache::CHI' => {
        driver => 'Memory',
        global => 1
    }
};


my $dsc = Dancer::Session::CHI->new();

my $plugin_cache  = cache();
my $session_cache = Dancer::Session::CHI::cache();

ok( $session_cache, "Session cache set" );
is(ref($plugin_cache), ref($session_cache), "Caches match");
$plugin_cache->set('key1', 'val1');
is( $plugin_cache->get('key1'), 'val1', "Plugin cache is working" );
is( $session_cache->get('key1'), 'val1', "Session cache is working" );
$session_cache->set('key1', 'val2');
is( $plugin_cache->get('key1'), 'val2', "Plugin cache is working" );
is( $session_cache->get('key1'), 'val2', "Session cache is working" );

done_testing;
exit;

