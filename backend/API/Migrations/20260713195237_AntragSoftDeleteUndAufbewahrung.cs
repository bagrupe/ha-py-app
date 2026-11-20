using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AntragSoftDeleteUndAufbewahrung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Instant>(
                name: "GeloeschtAm",
                table: "Ausfuehrungen",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "GeloeschtVonId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Loeschgrund",
                table: "Ausfuehrungen",
                type: "text",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "AntragLoeschProtokolle",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AusfuehrungId = table.Column<Guid>(type: "uuid", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: true),
                    Ereignis = table.Column<int>(type: "integer", nullable: false),
                    AusgefuehrtVonId = table.Column<Guid>(type: "uuid", nullable: true),
                    AusgefuehrtVonEmail = table.Column<string>(type: "text", nullable: true),
                    Grund = table.Column<string>(type: "text", nullable: true),
                    Zeitpunkt = table.Column<Instant>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_AntragLoeschProtokolle", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AufbewahrungsEinstellungen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    HardDeleteVerzoegerungMinuten = table.Column<int>(type: "integer", nullable: false),
                    ArchivVerzoegerungMinuten = table.Column<int>(type: "integer", nullable: false),
                    HardDeleteAktiv = table.Column<bool>(type: "boolean", nullable: false),
                    ArchivierungAktiv = table.Column<bool>(type: "boolean", nullable: false),
                    AktualisiertVonId = table.Column<Guid>(type: "uuid", nullable: true),
                    AktualisiertAm = table.Column<Instant>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_AufbewahrungsEinstellungen", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "AntragLoeschProtokolle");

            migrationBuilder.DropTable(
                name: "AufbewahrungsEinstellungen");

            migrationBuilder.DropColumn(
                name: "GeloeschtAm",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "GeloeschtVonId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "Loeschgrund",
                table: "Ausfuehrungen");
        }
    }
}
