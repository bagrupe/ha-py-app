using System;
using System.Text.Json;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations.Archive {
    /// <inheritdoc />
    public partial class InitArchiv : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "ArchivierteAntraege",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false),
                    ProzessVersionId = table.Column<Guid>(type: "uuid", nullable: false),
                    ProzessBezeichnung = table.Column<string>(type: "text", nullable: true),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    AbgeschlossenAm = table.Column<Instant>(type: "timestamp with time zone", nullable: true),
                    ArchiviertAm = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    ZustaendigkeitArt = table.Column<int>(type: "integer", nullable: false),
                    ZustaendigkeitOrganisationseinheitId = table.Column<Guid>(type: "uuid", nullable: true),
                    ZustaendigkeitMitarbeiterGruppeId = table.Column<Guid>(type: "uuid", nullable: true),
                    ZustaendigkeitZugewiesenePersonId = table.Column<Guid>(type: "uuid", nullable: true),
                    ZustaendigkeitDienstleisterId = table.Column<Guid>(type: "uuid", nullable: true),
                    SharedKeyEncryptedForKommune = table.Column<string>(type: "text", nullable: false),
                    Inhalt = table.Column<JsonDocument>(type: "jsonb", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ArchivierteAntraege", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ArchivierteAntraege_AbgeschlossenAm",
                table: "ArchivierteAntraege",
                column: "AbgeschlossenAm");

            migrationBuilder.CreateIndex(
                name: "IX_ArchivierteAntraege_KommuneId",
                table: "ArchivierteAntraege",
                column: "KommuneId");

            migrationBuilder.CreateIndex(
                name: "IX_ArchivierteAntraege_ProzessVersionId",
                table: "ArchivierteAntraege",
                column: "ProzessVersionId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "ArchivierteAntraege");
        }
    }
}
