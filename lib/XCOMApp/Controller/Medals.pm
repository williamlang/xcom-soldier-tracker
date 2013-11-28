package XCOMApp::Controller::Medals;

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

    $c->response->body('Matched XCOMApp::Controller::Medals in Medals.');
}

sub medal_rest : Path : Args(1) : ActionClass('REST') {
    my ( $self, $c, $id ) = @_;

    my $medal = $c->model('Schema::Medal')->find($id);

    $self->status_not_found($c, entity => {
        message => "Medal does not exist."
    }) unless $medal;

    $c->stash->{medal} = $medal;
}

=head1 AUTHOR

William Lang,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;