package Debian::DEP12;

use strict;
use warnings;

# ABSTRACT: validator for DEP 12 format
# VERSION

use Data::Validate::URI qw( is_uri );
use Text::BibTeX::Validate qw( validate_BibTeX );
use YAML::XS;

$YAML::XS::LoadBlessed = 0;

sub new
{
    my( $class, $what ) = @_;

    my $self;
    if( ref $what eq '' ) {
        # Text in YAML format
        if( $YAML::XS::VERSION < 0.69 ) {
            die 'YAML::XS < 0.69 is insecure' . "\n";
        }

        $self = Load $what;
    } elsif( ref $what eq 'HASH' ) {
        $self = $what;
    } else {
        die 'can only create Debian::DEP12 from text or hash ref' . "\n";
    }

    return bless $self, $class;
}

sub fields
{
    return keys %{$_[0]};
}

sub get
{
    my( $self, $field ) = @_;
    return $self->{$field};
}

sub set
{
    my( $self, $field, $value ) = @_;
    ( my $old_value, $self->{$field} ) = ( $self->{$field}, $value );
    return $old_value;
}

sub delete
{
    my( $self, $field ) = @_;

    my $old_value = $self->{$field};
    delete $self->{$field};

    return $old_value;
}

sub _to_BibTeX
{
    my( $self ) = @_;

    my $reference = $self->get( 'Reference' );
    if( ref $reference eq 'HASH' ) {
        $reference = [ $reference ];
    }

    my @BibTeX;
    for my $reference (@$reference) {
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
        next if !defined $self->get( $key );
        next if  defined is_uri $self->get( $key );
        warn sprintf '%s: value \'%s\' does not look like valid URL' . "\n",
                     $key,
                     $self->get( $key );
    }

    for my $BibTeX ($self->_to_BibTeX) {
        validate_BibTeX( $BibTeX );
    }
}

1;
