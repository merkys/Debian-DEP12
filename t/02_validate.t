#!/usr/bin/perl

use strict;
use warnings;
use Debian::DEP12;

use Test::More tests => 4;

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

$entry = Debian::DEP12->new( <<END );
Reference:
  DOI: search for my surname and year
END

$entry->validate;

is( $warning, 'doi: value \'search for my surname and year\' does not look like valid DOI' );

$entry = Debian::DEP12->new( <<END );
Reference:
 - Year: 2021
 - DOI: search for my surname and year
END

$entry->validate;

is( $warning, 'doi: value \'search for my surname and year\' does not look like valid DOI' );

