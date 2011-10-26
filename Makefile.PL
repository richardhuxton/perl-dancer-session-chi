use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Dancer::Session::CHI',
    AUTHOR              => q{Richard Huxton <richard.huxton@gmail.com>},
    VERSION_FROM        => 'lib/Dancer/Session/CHI.pm',
    ABSTRACT_FROM       => 'lib/Dancer/Session/CHI.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'CHI'        => 0,
        'Dancer'     => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Dancer-Session-CHI-*' },
);
