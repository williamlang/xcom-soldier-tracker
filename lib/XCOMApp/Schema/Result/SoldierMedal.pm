use utf8;
package XCOMApp::Schema::Result::SoldierMedal;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

XCOMApp::Schema::Result::SoldierMedal

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

=head1 TABLE: C<soldier_medals>

=cut

__PACKAGE__->table("soldier_medals");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 soldier_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 medal_bonus_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "soldier_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "medal_bonus_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 medal_bonus

Type: belongs_to

Related object: L<XCOMApp::Schema::Result::MedalBonuse>

=cut

__PACKAGE__->belongs_to(
  "medal_bonus",
  "XCOMApp::Schema::Result::MedalBonus",
  { id => "medal_bonus_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 soldier

Type: belongs_to

Related object: L<XCOMApp::Schema::Result::Soldier>

=cut

__PACKAGE__->belongs_to(
  "soldier",
  "XCOMApp::Schema::Result::Soldier",
  { id => "soldier_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-11-17 17:03:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nR/ufjhXR8jamsnXSjQCHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
