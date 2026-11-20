using System.Collections.Immutable;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddFunktionsberechtigungen : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<ImmutableList<string>>(
                name: "Funktionsberechtigungen",
                table: "UntereinheitPermissions",
                type: "text[]",
                nullable: false,
                defaultValueSql: "'{}'");

            migrationBuilder.Sql($"""
                UPDATE "UntereinheitPermissions" SET "Funktionsberechtigungen" = array_append("Funktionsberechtigungen", 'InhaltspflegeNewsArtikel') WHERE "CanEditNews" = true ;
            """);

            migrationBuilder.Sql($"""
                UPDATE "UntereinheitPermissions" SET "Funktionsberechtigungen" = array_append("Funktionsberechtigungen", 'InhaltspflegeVeranstaltungen') WHERE "CanEditVeranstaltungen" = true;
            """);

            migrationBuilder.DropColumn(
                name: "CanEditNews",
                table: "UntereinheitPermissions");

            migrationBuilder.DropColumn(
                name: "CanEditVeranstaltungen",
                table: "UntereinheitPermissions");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Funktionsberechtigungen",
                table: "UntereinheitPermissions");

            migrationBuilder.AddColumn<bool>(
                name: "CanEditNews",
                table: "UntereinheitPermissions",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "CanEditVeranstaltungen",
                table: "UntereinheitPermissions",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }
    }
}
