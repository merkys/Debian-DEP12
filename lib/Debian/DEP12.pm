package Debian::DEP12;

use strict;
use warnings;

use Text::BibTeX::Validate qw( validate_BibTeX );

sub _to_BibTeX {
    my( $self ) = @_;

    my @BibTeX;
    for my $reference (@{$self->{Reference}}) {
        push @BibTeX,
             { map { lc( $_ ) => $reference->{$_} } keys %$reference };
    }
    return @BibTeX;
}

sub validate {
    my( $self ) = @_;

    for my $BibTeX ($self->_to_BibTeX) {
        validate_BibTeX( $BibTeX );
    }
}

1;
