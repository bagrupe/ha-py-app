using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class UserGroupUntereinheitRelationship : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "MitarbeiterGruppeUntereinheit",
                columns: table => new {
                    GruppenId = table.Column<Guid>(type: "uuid", nullable: false),
                    OrganisationseinheitenId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_MitarbeiterGruppeUntereinheit", x => new { x.GruppenId, x.OrganisationseinheitenId });
                    table.ForeignKey(
                        name: "FK_MitarbeiterGruppeUntereinheit_MitarbeiterGruppen_GruppenId",
                        column: x => x.GruppenId,
                        principalTable: "MitarbeiterGruppen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MitarbeiterGruppeUntereinheit_Untereinheit_Organisationsein~",
                        column: x => x.OrganisationseinheitenId,
                        principalTable: "Untereinheit",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_MitarbeiterGruppeUntereinheit_OrganisationseinheitenId",
                table: "MitarbeiterGruppeUntereinheit",
                column: "OrganisationseinheitenId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "MitarbeiterGruppeUntereinheit");
        }
    }
}
