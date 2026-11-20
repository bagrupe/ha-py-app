using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddGlobaleFunktionsberechtigungen : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string[]>(
                name: "Funktionsberechtigungen",
                table: "Users",
                type: "text[]",
                nullable: true,
                defaultValueSql: "'{}'");

            migrationBuilder.Sql($"""
                UPDATE "Users" SET "IsSyncedToBereichB" = false WHERE "IsSyncedToBereichB" = true;
            """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Funktionsberechtigungen",
                table: "Users");
        }
    }
}
