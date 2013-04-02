package XCOMApp::View::Mason;

use strict;
use warnings;

use parent 'Catalyst::View::Mason';

__PACKAGE__->config(
    use_match => 0,
    template_extension => '.mason'
);

=head1 NAME

XCOMApp::View::Mason - Mason View Component for XCOMApp

=head1 DESCRIPTION

Mason View Component for XCOMApp

=head1 SEE ALSO

L<XCOMApp>, L<HTML::Mason>

=head1 AUTHOR

William Lang,,,

=head1 LICENSE

This library is free software . You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
