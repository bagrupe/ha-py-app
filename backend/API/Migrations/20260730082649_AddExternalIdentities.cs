using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddExternalIdentities : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "ExternalIdentities",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BuergerId = table.Column<Guid>(type: "uuid", nullable: false),
                    Provider = table.Column<string>(type: "text", nullable: false),
                    Issuer = table.Column<string>(type: "text", nullable: false),
                    SubjectHash = table.Column<string>(type: "text", nullable: false),
                    AssuranceLevel = table.Column<string>(type: "text", nullable: true),
                    LinkedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    LastAuthenticatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ExternalIdentities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ExternalIdentities_Users_BuergerId",
                        column: x => x.BuergerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ExternalIdentities_BuergerId",
                table: "ExternalIdentities",
                column: "BuergerId");

            migrationBuilder.CreateIndex(
                name: "IX_ExternalIdentities_Provider_Issuer_SubjectHash",
                table: "ExternalIdentities",
                columns: new[] { "Provider", "Issuer", "SubjectHash" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "ExternalIdentities");
        }
    }
}
