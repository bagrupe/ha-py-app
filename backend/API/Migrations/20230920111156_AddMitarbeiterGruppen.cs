using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddMitarbeiterGruppen : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "ErledigungDurchBuerger",
                table: "Schritte");

            migrationBuilder.AddColumn<Guid>(
                name: "MitarbeiterGruppeId",
                table: "Schritte",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "MitarbeiterGruppen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_MitarbeiterGruppen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MitarbeiterGruppen_Kommunen_KommuneId",
                        column: x => x.KommuneId,
                        principalTable: "Kommunen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MitarbeiterMitarbeiterGruppe",
                columns: table => new {
                    GruppenId = table.Column<Guid>(type: "uuid", nullable: false),
                    MitarbeiterId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_MitarbeiterMitarbeiterGruppe", x => new { x.GruppenId, x.MitarbeiterId });
                    table.ForeignKey(
                        name: "FK_MitarbeiterMitarbeiterGruppe_MitarbeiterGruppen_GruppenId",
                        column: x => x.GruppenId,
                        principalTable: "MitarbeiterGruppen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MitarbeiterMitarbeiterGruppe_Users_MitarbeiterId",
                        column: x => x.MitarbeiterId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_MitarbeiterGruppeId",
                table: "Schritte",
                column: "MitarbeiterGruppeId");

            migrationBuilder.CreateIndex(
                name: "IX_MitarbeiterGruppen_KommuneId",
                table: "MitarbeiterGruppen",
                column: "KommuneId");

            migrationBuilder.CreateIndex(
                name: "IX_MitarbeiterMitarbeiterGruppe_MitarbeiterId",
                table: "MitarbeiterMitarbeiterGruppe",
                column: "MitarbeiterId");

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_MitarbeiterGruppen_MitarbeiterGruppeId",
                table: "Schritte",
                column: "MitarbeiterGruppeId",
                principalTable: "MitarbeiterGruppen",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_MitarbeiterGruppen_MitarbeiterGruppeId",
                table: "Schritte");

            migrationBuilder.DropTable(
                name: "MitarbeiterMitarbeiterGruppe");

            migrationBuilder.DropTable(
                name: "MitarbeiterGruppen");

            migrationBuilder.DropIndex(
                name: "IX_Schritte_MitarbeiterGruppeId",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "MitarbeiterGruppeId",
                table: "Schritte");

            migrationBuilder.AddColumn<bool>(
                name: "ErledigungDurchBuerger",
                table: "Schritte",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }
    }
}
