using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class Nutzerverwaltung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<int>(
                name: "Art",
                table: "Users",
                type: "integer",
                nullable: true);

            migrationBuilder.Sql(@"
                UPDATE ""Users""
                SET ""Art"" = CASE
                    WHEN ""IsKommuneAdmin"" = TRUE THEN 1
                    ELSE 0
                END
                WHERE ""Discriminator"" = 'BackofficeUser';
            ");

            migrationBuilder.DropColumn(
                name: "IsKommuneAdmin",
                table: "Users");

            migrationBuilder.AddColumn<Guid>(
                name: "InvitationCode",
                table: "Users",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "InvitationValidUntil",
                table: "Users",
                type: "timestamp with time zone",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Art",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "InvitationCode",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "InvitationValidUntil",
                table: "Users");

            migrationBuilder.AddColumn<bool>(
                name: "IsKommuneAdmin",
                table: "Users",
                type: "boolean",
                nullable: true);
        }
    }
}
