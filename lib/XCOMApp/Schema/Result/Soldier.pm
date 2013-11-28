use utf8;
package XCOMApp::Schema::Result::Soldier;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

XCOMApp::Schema::Result::Soldier

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

=head1 TABLE: C<soldiers>

=cut

__PACKAGE__->table("soldiers");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 first_name

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 last_name

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 nick_name

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 will

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 aim

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 hp

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 dead

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 psionic

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 country_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 class_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 rank_id

  data_type: 'integer'
  default_value: 1
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "first_name",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "last_name",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "nick_name",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "will",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "aim",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "hp",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "dead",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "psionic",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "country_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "class_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "rank_id",
  {
    data_type      => "integer",
    default_value  => 1,
    is_foreign_key => 1,
    is_nullable    => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 class

Type: belongs_to

Related object: L<XCOMApp::Schema::Result::Class>

=cut

__PACKAGE__->belongs_to(
  "class",
  "XCOMApp::Schema::Result::Class",
  { id => "class_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 country

Type: belongs_to

Related object: L<XCOMApp::Schema::Result::Country>

=cut

__PACKAGE__->belongs_to(
  "country",
  "XCOMApp::Schema::Result::Country",
  { id => "country_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 rank

Type: belongs_to

Related object: L<XCOMApp::Schema::Result::Rank>

=cut

__PACKAGE__->belongs_to(
  "rank",
  "XCOMApp::Schema::Result::Rank",
  { id => "rank_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 soldier_gene_mods

Type: has_many

Related object: L<XCOMApp::Schema::Result::SoldierGeneMod>

=cut

__PACKAGE__->has_many(
  "soldier_gene_mods",
  "XCOMApp::Schema::Result::SoldierGeneMod",
  { "foreign.soldier_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 soldier_histories

Type: has_many

Related object: L<XCOMApp::Schema::Result::SoldierHistory>

=cut

__PACKAGE__->has_many(
  "soldier_histories",
  "XCOMApp::Schema::Result::SoldierHistory",
  { "foreign.soldier_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 soldier_medals

Type: has_many

Related object: L<XCOMApp::Schema::Result::SoldierMedal>

=cut

__PACKAGE__->has_many(
  "soldier_medals",
  "XCOMApp::Schema::Result::SoldierMedal",
  { "foreign.soldier_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-11-17 17:03:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ymZULouKP26dAZdQLTIAvA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
