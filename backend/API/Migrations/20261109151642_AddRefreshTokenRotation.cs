using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddRefreshTokenRotation : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "Provider",
                table: "BundIdRefreshTokens",
                type: "text",
                nullable: false,
                defaultValue: "bundid");

            migrationBuilder.AddColumn<Guid>(
                name: "ReplacedById",
                table: "BundIdRefreshTokens",
                type: "uuid",
                nullable: true);

            migrationBuilder.Sql(
                """
                UPDATE "Users" SET "Phone" = NULL, "PhoneHash" = NULL, "PhoneVerified" = false
                WHERE "Discriminator" = 'Buerger' AND "IsDeleted" AND "PhoneHash" IS NOT NULL
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql("""DELETE FROM "BundIdRefreshTokens" WHERE "Provider" <> 'bundid'""");

            migrationBuilder.DropColumn(
                name: "Provider",
                table: "BundIdRefreshTokens");

            migrationBuilder.DropColumn(
                name: "ReplacedById",
                table: "BundIdRefreshTokens");
        }
    }
}
