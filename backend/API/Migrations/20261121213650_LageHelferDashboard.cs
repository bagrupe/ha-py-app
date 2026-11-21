using System;
using System.Text.Json;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class LageHelferDashboard : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateSequence<int>(
                name: "Meldungsnummern",
                startValue: 1000L);

            migrationBuilder.AddColumn<Guid>(
                name: "EinheitId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "KlaerungKommentar",
                table: "Ausfuehrungen",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "KlaerungSeit",
                table: "Ausfuehrungen",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Meldungsnummer",
                table: "Ausfuehrungen",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "PublicId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "VerwerfenGrund",
                table: "Ausfuehrungen",
                type: "text",
                nullable: true);

            // Reports filed before this migration get a number and a public handle like new ones.
            migrationBuilder.Sql("""
                UPDATE "Ausfuehrungen"
                SET "PublicId" = gen_random_uuid(), "Meldungsnummer" = nextval('"Meldungsnummern"')
                WHERE "LageGebietId" IS NOT NULL;
                """);

            migrationBuilder.CreateTable(
                name: "Einheiten",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    MitarbeiterGruppeId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Einheiten", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Einheiten_MitarbeiterGruppen_MitarbeiterGruppeId",
                        column: x => x.MitarbeiterGruppeId,
                        principalTable: "MitarbeiterGruppen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MeldungBestaetigungen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AusfuehrungId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    Fotos = table.Column<JsonElement>(type: "jsonb", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_MeldungBestaetigungen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MeldungBestaetigungen_Ausfuehrungen_AusfuehrungId",
                        column: x => x.AusfuehrungId,
                        principalTable: "Ausfuehrungen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_EinheitId",
                table: "Ausfuehrungen",
                column: "EinheitId");

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_Meldungsnummer",
                table: "Ausfuehrungen",
                column: "Meldungsnummer",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_PublicId",
                table: "Ausfuehrungen",
                column: "PublicId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Einheiten_MitarbeiterGruppeId_Name",
                table: "Einheiten",
                columns: new[] { "MitarbeiterGruppeId", "Name" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_MeldungBestaetigungen_AusfuehrungId",
                table: "MeldungBestaetigungen",
                column: "AusfuehrungId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Einheiten_EinheitId",
                table: "Ausfuehrungen",
                column: "EinheitId",
                principalTable: "Einheiten",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Einheiten_EinheitId",
                table: "Ausfuehrungen");

            migrationBuilder.DropTable(
                name: "Einheiten");

            migrationBuilder.DropTable(
                name: "MeldungBestaetigungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_EinheitId",
                table: "Ausfuehrungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_Meldungsnummer",
                table: "Ausfuehrungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_PublicId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "EinheitId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "KlaerungKommentar",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "KlaerungSeit",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "Meldungsnummer",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "PublicId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "VerwerfenGrund",
                table: "Ausfuehrungen");

            migrationBuilder.DropSequence(
                name: "Meldungsnummern");
        }
    }
}
