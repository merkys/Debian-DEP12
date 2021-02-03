package Debian::DEP12;

use strict;
use warnings;

# ABSTRACT: validator for DEP 12 format
# VERSION

use Data::Validate::URI qw( is_uri );
use Text::BibTeX::Validate qw( validate_BibTeX );

sub _to_BibTeX
{
    my( $self ) = @_;

    my @BibTeX;
    for my $reference (@{$self->{Reference}}) {
        push @BibTeX,
             { map { lc( $_ ) => $reference->{$_} } keys %$reference };
    }
    return @BibTeX;
}

sub validate
{
    my( $self ) = @_;

    # TODO: validate other fields

    for my $key ('Bug-Database', 'Bug-Submit', 'Documentation',
                 'Donation', 'FAQ', 'Gallery', 'Other-References',
                 'Registration', 'Repository', 'Repository-Browse',
                 'Webservice') {
        next if !exists $self->{$key};
        next if defined is_uri $self->{$key};
        warn sprintf '%s: value \'%s\' does not look like valid URL' . "\n",
                     $key,
                     $self->{$key};
    }

    for my $BibTeX ($self->_to_BibTeX) {
        validate_BibTeX( $BibTeX );
    }
}

1;
