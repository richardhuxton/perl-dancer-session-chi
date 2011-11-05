use warnings;
use strict;
use Test::More;
use Test::Exception;

use Dancer::Session;
use Dancer::Config 'setting';
use Dancer::Session::CHI;

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


setting 'session'     => 'CHI';
setting 'session_via' => 'Foo::Bar::cache';

use Dancer::Session::CHI;
my $dsc = Dancer::Session::CHI->new();

lives_ok { Dancer::Session::CHI::_call_via('Foo::Bar::cache'); } "Call to real sub worked";
dies_ok  { Dancer::Session::CHI::_call_via('Foo::Bar::xyzzy'); } "Call to missing sub died (good)";
dies_ok  { Dancer::Session::CHI::_call_via('Foo`Bar::cache'); } "Call to badly formatted sub died (good)";

done_testing;
exit;
