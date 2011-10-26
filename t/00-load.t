#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Dancer::Session::CHI' ) || print "Bail out!
";
}

diag( "Testing Dancer::Session:CHI $Dancer::Session::CHI::VERSION, Perl $], $^X" );
