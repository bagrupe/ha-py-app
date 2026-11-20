using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddBundIdRefreshTokens : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "BundIdRefreshTokens",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BuergerId = table.Column<Guid>(type: "uuid", nullable: false),
                    TokenHash = table.Column<string>(type: "text", nullable: false),
                    AssuranceLevel = table.Column<string>(type: "text", nullable: true),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    ExpiresAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    RevokedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_BundIdRefreshTokens", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BundIdRefreshTokens_Users_BuergerId",
                        column: x => x.BuergerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BundIdRefreshTokens_BuergerId",
                table: "BundIdRefreshTokens",
                column: "BuergerId");

            migrationBuilder.CreateIndex(
                name: "IX_BundIdRefreshTokens_TokenHash",
                table: "BundIdRefreshTokens",
                column: "TokenHash",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "BundIdRefreshTokens");
        }
    }
}
