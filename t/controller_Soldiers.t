use strict;
use warnings;
use Test::More;


use Catalyst::Test 'XCOMApp';
use XCOMApp::Controller::Soldiers;

ok( request('/soldiers')->is_success, 'Request should succeed' );
done_testing();
