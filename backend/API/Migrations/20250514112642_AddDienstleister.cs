using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddDienstleister : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "Dienstleister",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    MandantId = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    EMail = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Dienstleister", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Dienstleister_Kommunen_MandantId",
                        column: x => x.MandantId,
                        principalTable: "Kommunen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BackofficeUserDienstleister",
                columns: table => new {
                    DienstleisterId = table.Column<Guid>(type: "uuid", nullable: false),
                    MitarbeiterId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_BackofficeUserDienstleister", x => new { x.DienstleisterId, x.MitarbeiterId });
                    table.ForeignKey(
                        name: "FK_BackofficeUserDienstleister_Dienstleister_DienstleisterId",
                        column: x => x.DienstleisterId,
                        principalTable: "Dienstleister",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BackofficeUserDienstleister_Users_MitarbeiterId",
                        column: x => x.MitarbeiterId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "DienstleisterOrganisationseinheit",
                columns: table => new {
                    DienstleisterId = table.Column<Guid>(type: "uuid", nullable: false),
                    OrganisationseinheitId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_DienstleisterOrganisationseinheit", x => new { x.DienstleisterId, x.OrganisationseinheitId });
                    table.ForeignKey(
                        name: "FK_DienstleisterOrganisationseinheit_Dienstleister_Dienstleist~",
                        column: x => x.DienstleisterId,
                        principalTable: "Dienstleister",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_DienstleisterOrganisationseinheit_Untereinheit_Organisation~",
                        column: x => x.OrganisationseinheitId,
                        principalTable: "Untereinheit",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BackofficeUserDienstleister_MitarbeiterId",
                table: "BackofficeUserDienstleister",
                column: "MitarbeiterId");

            migrationBuilder.CreateIndex(
                name: "IX_Dienstleister_MandantId",
                table: "Dienstleister",
                column: "MandantId");

            migrationBuilder.CreateIndex(
                name: "IX_DienstleisterOrganisationseinheit_OrganisationseinheitId",
                table: "DienstleisterOrganisationseinheit",
                column: "OrganisationseinheitId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "BackofficeUserDienstleister");

            migrationBuilder.DropTable(
                name: "DienstleisterOrganisationseinheit");

            migrationBuilder.DropTable(
                name: "Dienstleister");
        }
    }
}
