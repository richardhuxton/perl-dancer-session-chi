use Test::More tests => 3;

BEGIN {
    use_ok( 'Dancer::Session::CHI' ) || print "Bail out!\n";
    use_ok( 'Dancer::Session::Abstract' ) || print "Bail out!\n";
    use_ok( 'CHI' ) || print "Bail out!\n";
}

diag( "Testing Dancer::Session:CHI $Dancer::Session::CHI::VERSION, Perl $], $^X" );
