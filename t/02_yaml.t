#!/usr/bin/perl

use strict;
use warnings;
use Debian::DEP12;

use Test::More tests => 2;

my $entry;
my $warning;
local $SIG{__WARN__} = sub { $warning = $_[0]; $warning =~ s/\n$// };

$entry = Debian::DEP12->new( <<END );
Bug-Database: https://github.com/merkys/Debian-DEP12/issues
Bug-Submit: https://github.com/merkys/Debian-DEP12/issues
END

$entry->validate;

is( $warning, undef );

$entry = Debian::DEP12->new( <<END );
Bug-Database: github.com/merkys/Debian-DEP12/issues
END

$entry->validate;

is( $warning, 'Bug-Database: value \'github.com/merkys/Debian-DEP12/issues\' does not look like valid URL' );
