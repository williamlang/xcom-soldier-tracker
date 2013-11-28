package XCOMApp::Controller::Root;

use Moose;
use namespace::autoclean;
use XCOMApp::Schema::Result::GeneMod;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

XCOMApp::Controller::Root - Root Controller for XCOMApp

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my @countries = $c->model('Schema::Country')->search(undef, {
        result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    })->all;

    my @ranks = $c->model('Schema::Rank')->search(undef, {
        result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    })->all;

    my @classes = $c->model('Schema::Class')->search(undef, {
        result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    })->all;

    my @soldiers = $c->model('Schema::Soldier')->search(undef, {
        prefetch => [ qw/ country class rank soldier_histories / ],
        result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    })->all;

    my @gene_mods = $c->model('Schema::GeneMod')->search(undef, {
        result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    })->all;

    my @gene_mod_types = @{ $c->model('Schema::GeneMod')->result_source->column_info('type')->{ extra }->{ list } };

    $c->stash->{countries} = \@countries;
    $c->stash->{ranks}     = \@ranks;
    $c->stash->{classes}   = \@classes;
    $c->stash->{soldiers}  = \@soldiers;
    $c->stash->{gene_mods} = \@gene_mods;
    $c->stash->{gene_mod_types } = \@gene_mod_types;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

William Lang,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
