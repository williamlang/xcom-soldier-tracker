package XCOMApp::Controller::Soldiers;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::REST'; }

=head1 NAME

XCOMApp::Controller::Soldiers - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path('index') :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched XCOMApp::Controller::Soldiers in Soldiers.');
}

sub soldier_rest : Path : Args(1) : ActionClass('REST') {
    my ( $self, $c, $id ) = @_;

    my $soldier = $c->model('Schema::Soldier')->find($id);

    $self->status_not_found($c, entity => {
        message => "Soldier does not exist."
    }) unless $soldier;

    $c->stash->{soldier} = $soldier;
}

sub soldier_rest_GET {
    my ( $self, $c ) = @_;

    my $soldier = $c->stash->{soldier};

    $soldier = $c->model('Schema::Soldier')->find($soldier->id, {
        prefetch => [ qw/ country rank class soldier_histories /],
        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    });

    $self->status_ok($c, entity => {
        soldier => $soldier
    });
}

sub soldier_rest_POST {
    my ( $self, $c ) = @_;

    my $data = $c->req->data;

    my $soldier = $c->stash->{soldier};

    if ($soldier->soldier_histories->count == 0) {
        $soldier->create_related('soldier_histories', {
            will => $soldier->will,
            aim  => $soldier->aim,
            hp   => $soldier->hp
        });
    }

    my $result = $soldier->update( $data );

    if ($result) {
        $soldier->create_related('soldier_histories', {
            will => $soldier->will,
            aim  => $soldier->aim,
            hp   => $soldier->hp
        });

        $soldier = $c->model('Schema::Soldier')->find($soldier->id, {
            prefetch => [ qw/ country rank class soldier_histories /],
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        });

        $self->status_ok($c, entity => {
            soldier => $soldier
        });
    }
    else {
        $self->status_bad_request($c, entity => {
            message => "Unable to save soldier.",
        });
    }
}

sub soldier_rest_DELETE {
    my ( $self, $c ) = @_;

    my $soldier = $c->stash->{soldier};
    $soldier->delete;

    $self->status_ok($c, entity => { message => "Deleted" });
}

sub soldiers_rest : Path : Args(0) : ActionClass('REST') {
    my ( $self, $c ) = @_;
}

sub soldiers_rest_GET {
    my ( $self, $c ) = @_;

    my @soldiers = $c->model('Schema::Soldier')->search(undef, {
        prefetch => [ qw/ country rank class soldier_histories /],
        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    })->all;

    $self->status_ok($c, entity => {
        soldiers => \@soldiers
    });
}

sub soldiers_rest_POST {
    my ( $self, $c ) = @_;

    my $data = $c->req->data;

    my $soldier = $c->model('Schema::Soldier')->create( $data );

    if ($soldier) {
        $soldier->create_related('soldier_histories', {
            will => $soldier->will,
            aim  => $soldier->aim,
            hp   => $soldier->hp
        });

        $soldier = $c->model('Schema::Soldier')->find($soldier->id, {
            prefetch => [ qw/ country rank class soldier_histories /],
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        });

        $self->status_created($c, 
            location => $c->req->uri . '/' . $soldier->{id},
            entity => {
            soldier => $soldier
        });
    }
    else {
        $self->status_bad_request($c, entity => {
            message => "Unable to create soldier."
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
