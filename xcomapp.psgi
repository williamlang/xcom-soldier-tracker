use strict;
use warnings;

use XCOMApp;

my $app = XCOMApp->apply_default_middlewares(XCOMApp->psgi_app);
$app;

