use utf8;
package XCOMApp::Schema::Result::Country;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

XCOMApp::Schema::Result::Country

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<countries>

=cut

__PACKAGE__->table("countries");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 iso2

  data_type: 'char'
  is_nullable: 1
  size: 2

=head2 short_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 80

=head2 long_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 80

=head2 iso3

  data_type: 'char'
  is_nullable: 1
  size: 3

=head2 numcode

  data_type: 'varchar'
  is_nullable: 1
  size: 6

=head2 un_member

  data_type: 'varchar'
  is_nullable: 1
  size: 12

=head2 calling_code

  data_type: 'varchar'
  is_nullable: 1
  size: 8

=head2 cctld

  data_type: 'varchar'
  is_nullable: 1
  size: 5

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "iso2",
  { data_type => "char", is_nullable => 1, size => 2 },
  "short_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 80 },
  "long_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 80 },
  "iso3",
  { data_type => "char", is_nullable => 1, size => 3 },
  "numcode",
  { data_type => "varchar", is_nullable => 1, size => 6 },
  "un_member",
  { data_type => "varchar", is_nullable => 1, size => 12 },
  "calling_code",
  { data_type => "varchar", is_nullable => 1, size => 8 },
  "cctld",
  { data_type => "varchar", is_nullable => 1, size => 5 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 soldiers

Type: has_many

Related object: L<XCOMApp::Schema::Result::Soldier>

=cut

__PACKAGE__->has_many(
  "soldiers",
  "XCOMApp::Schema::Result::Soldier",
  { "foreign.country_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-11-16 12:41:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fb9XYJ0NDdgcskl4yp2ITw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
