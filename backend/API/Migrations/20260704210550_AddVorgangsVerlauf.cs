using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddVorgangsVerlauf : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "VerlaufsEintraege",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AusfuehrungId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    Art = table.Column<int>(type: "integer", nullable: false),
                    BenutzerId = table.Column<Guid>(type: "uuid", nullable: true),
                    BenutzerName = table.Column<string>(type: "text", nullable: true),
                    Zielbeschreibung = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_VerlaufsEintraege", x => x.Id);
                    table.ForeignKey(
                        name: "FK_VerlaufsEintraege_Ausfuehrungen_AusfuehrungId",
                        column: x => x.AusfuehrungId,
                        principalTable: "Ausfuehrungen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_VerlaufsEintraege_AusfuehrungId",
                table: "VerlaufsEintraege",
                column: "AusfuehrungId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "VerlaufsEintraege");
        }
    }
}
