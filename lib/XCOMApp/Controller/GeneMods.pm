package XCOMApp::Controller::GeneMods;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::REST'; }

=head1 NAME

XCOMApp::Controller::Medals - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut


sub index :Path('index') :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched XCOMApp::Controller::GeneMods in GeneMods.');
}

sub gene_mod_rest : Path : Args(1) : ActionClass('REST') {
    my ( $self, $c, $id ) = @_;

    my $gene_mod = $c->model('Schema::GeneMod')->find($id);

    $self->status_not_found($c, entity => {
        message => "GeneMod does not exist."
    }) unless $gene_mod;

    $c->stash->{gene_mod} = $gene_mod;
}

sub gene_mod_rest_GET {
    my ( $self, $c ) = @_;

    my $gene_mod = $c->stash->{gene_mod};

    $gene_mod = $c->model('Schema::GeneMod')->find($gene_mod->id, {
        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    });

    $self->status_ok($c, entity => {
        gene_mod => $gene_mod
    });
}

sub gene_mods_rest : Path : Args(0) : ActionClass('REST') {
    my ( $self, $c ) = @_;
}

sub gene_mods_rest_GET {
    my ( $self, $c ) = @_;

    my @gene_mods = $c->model('Schema::GeneMod')->search(undef, {
        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    })->all;

    $self->status_ok($c, entity => {
        gene_mods => \@gene_mods
    });
}

sub gene_mods_rest_POST {
    my ( $self, $c ) = @_;

    my $data = $c->req->data || $c->req->params;

    my $gene_mod = $c->model('Schema::GeneMod')->create( $data );

    if ($gene_mod) {
        $gene_mod = $c->model('Schema::GeneMod')->find($gene_mod->id, {
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        });

        $self->status_created($c,
            location => $c->req->uri . '/' . $gene_mod->{id},
            entity => {
        	    gene_mod => $gene_mod
        	}
        );
    }
    else {
        $self->status_bad_request($c, entity => {
            message => "Unable to create gene mod."
        });
    }
}


=head1 AUTHOR

William Lang,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;