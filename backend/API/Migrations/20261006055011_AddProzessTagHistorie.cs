using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddProzessTagHistorie : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "ProzessTagHistorie",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ProzessId = table.Column<Guid>(type: "uuid", nullable: false),
                    TagId = table.Column<Guid>(type: "uuid", nullable: false),
                    ZugewiesenAm = table.Column<Instant>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ProzessTagHistorie", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ProzessTagHistorie_ProzessTags_TagId",
                        column: x => x.TagId,
                        principalTable: "ProzessTags",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ProzessTagHistorie_UserFacingProzesse_ProzessId",
                        column: x => x.ProzessId,
                        principalTable: "UserFacingProzesse",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ProzessTagHistorie_ProzessId_TagId",
                table: "ProzessTagHistorie",
                columns: new[] { "ProzessId", "TagId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ProzessTagHistorie_TagId",
                table: "ProzessTagHistorie",
                column: "TagId");

            // Backfill nur für aktuelle Träger - frühere, schon wieder entzogene Zuweisungen sind nirgends
            // festgehalten und damit nicht rekonstruierbar.
            migrationBuilder.Sql("""
                INSERT INTO "ProzessTagHistorie" ("Id", "ProzessId", "TagId", "ZugewiesenAm")
                SELECT gen_random_uuid(), "ProzesseId", "TagsId", now()
                FROM "ProzessProzessTag"
                ON CONFLICT DO NOTHING;
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "ProzessTagHistorie");
        }
    }
}
