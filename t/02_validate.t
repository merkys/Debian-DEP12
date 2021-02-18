#!/usr/bin/perl

use strict;
use warnings;
use Debian::DEP12;

use Test::More tests => 6;

my $entry;
my $warning;
my @warnings;

$entry = Debian::DEP12->new( <<END );
Bug-Database: https://github.com/merkys/Debian-DEP12/issues
Bug-Submit: https://github.com/merkys/Debian-DEP12/issues
END

@warnings = $entry->validate;
is( scalar @warnings, 0 );

$entry = Debian::DEP12->new( <<END );
Bug-Database: github.com/merkys/Debian-DEP12/issues
END

@warnings = $entry->validate;
is( "@warnings", 'Bug-Database: value \'github.com/merkys/Debian-DEP12/issues\' does not look like valid URL' );

$entry = Debian::DEP12->new;
$entry->set( 'Bug-Database', 'github.com/merkys/Debian-DEP12/issues' );

@warnings = $entry->validate;
is( "@warnings", 'Bug-Database: value \'github.com/merkys/Debian-DEP12/issues\' does not look like valid URL' );

$entry = Debian::DEP12->new( <<END );
Reference:
  DOI: search for my surname and year
END

@warnings = $entry->validate;
is( "@warnings", '0: DOI: value \'search for my surname and year\' does not look like valid DOI' );

$entry = Debian::DEP12->new( <<END );
Reference:
 - Year: 2021
 - DOI: search for my surname and year
END

@warnings = $entry->validate;
is( "@warnings", '1: DOI: value \'search for my surname and year\' does not look like valid DOI' );

$entry = Debian::DEP12->new( { 'Bug-Submit' => 'merkys@cpan.org' } );
@warnings = $entry->validate;
is( "@warnings", 'Bug-Submit: value \'merkys@cpan.org\' is better written as \'mailto:merkys@cpan.org\'' );
