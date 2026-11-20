using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddGebietEinsatzleitung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "GebietEinsatzleitungen",
                columns: table => new {
                    GebietId = table.Column<Guid>(type: "uuid", nullable: false),
                    MitarbeiterGruppeId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_GebietEinsatzleitungen", x => new { x.GebietId, x.MitarbeiterGruppeId });
                    table.ForeignKey(
                        name: "FK_GebietEinsatzleitungen_Gebiete_GebietId",
                        column: x => x.GebietId,
                        principalTable: "Gebiete",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_GebietEinsatzleitungen_MitarbeiterGruppen_MitarbeiterGruppe~",
                        column: x => x.MitarbeiterGruppeId,
                        principalTable: "MitarbeiterGruppen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_GebietEinsatzleitungen_MitarbeiterGruppeId",
                table: "GebietEinsatzleitungen",
                column: "MitarbeiterGruppeId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "GebietEinsatzleitungen");
        }
    }
}
