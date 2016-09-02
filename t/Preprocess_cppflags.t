use strict;
use warnings;
use diagnostics;
use Config;
BEGIN {
    mkdir '_In line';
}

print "1..4\n";


use Inline C => Config =>
    DIRECTORY  => '_In line', #space in path test
    #BUILD_NOISY => 1,
    FORCE_BUILD => 1,
    CCFLAGS     => $Config{ccflags};

use Inline C => <<'END' => CPPFLAGS => ' -DPREPROCESSOR_DEFINE' => FILTERS => 'Preprocess';
#ifdef PREPROCESSOR_DEFINE
int foo() { return 4321; }
#else
int foo() { return -1; }
#endif
END

my $foo_retval = foo();

if ( $foo_retval == 4321 ) {
    print "ok 1\n";
}
else {
    warn "\n Expected: 4321\n Got: $foo_retval\n";
    print "not ok 1\n";
}

use Inline C => <<'END' => FILTERS => 'Preprocess';
#ifdef PREPROCESSOR_DEFINE
int bar() { return 4321; }
#else
int bar() { return -1; }
#endif
END

my $bar_retval = bar();

if ( $bar_retval == -1 ) {
    print "ok 2\n";
}
else {
    warn "\n Expected: -1\n Got: $bar_retval\n";
    print "not ok 2\n";
}

use Inline C => <<'END';
#ifdef PREPROCESSOR_DEFINE
int bat() { return 4321; }
#else
int bat() { return -1; }
#endif
END

my $bat_retval = bat();

if ( $bat_retval == -1 ) {
    print "ok 3\n";
}
else {
    warn "\n Expected: -1\n Got: $bat_retval\n";
    print "not ok 3\n";
}


use Inline C => <<'END' => CPPFLAGS => ' -DPREPROCESSOR_DEFINE -DNUMERIC_DEFINE=2112' => FILTERS => 'Preprocess';
#ifdef PREPROCESSOR_DEFINE
int baz() { return NUMERIC_DEFINE; }
#else
int baz() { return -1; }
#endif
END

my $baz_retval = baz();

if ( $baz_retval == 2112 ) {
    print "ok 4\n";
}
else {
    warn "\n Expected: 2112\n Got: $baz_retval\n";
    print "not ok 4\n";
}