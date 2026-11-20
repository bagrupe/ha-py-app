using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddKategorieBaum : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "Kategorien",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false),
                    ParentId = table.Column<Guid>(type: "uuid", nullable: true),
                    UntereinheitId = table.Column<Guid>(type: "uuid", nullable: true),
                    IstWurzel = table.Column<bool>(type: "boolean", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Ziel_Art = table.Column<int>(type: "integer", nullable: true),
                    Ziel_OrganisationseinheitId = table.Column<Guid>(type: "uuid", nullable: true),
                    Ziel_MitarbeiterGruppeId = table.Column<Guid>(type: "uuid", nullable: true),
                    Ziel_DienstleisterId = table.Column<Guid>(type: "uuid", nullable: true),
                    Ziel_ZugewiesenePersonId = table.Column<Guid>(type: "uuid", nullable: true),
                    Ziel_LiestRolleId = table.Column<Guid>(type: "uuid", nullable: true),
                    Ziel_DynamischeArten = table.Column<int[]>(type: "integer[]", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Kategorien", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Kategorien_Dienstleister_Ziel_DienstleisterId",
                        column: x => x.Ziel_DienstleisterId,
                        principalTable: "Dienstleister",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Kategorien_Kategorien_ParentId",
                        column: x => x.ParentId,
                        principalTable: "Kategorien",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Kategorien_MitarbeiterGruppen_Ziel_MitarbeiterGruppeId",
                        column: x => x.Ziel_MitarbeiterGruppeId,
                        principalTable: "MitarbeiterGruppen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Kategorien_Untereinheit_UntereinheitId",
                        column: x => x.UntereinheitId,
                        principalTable: "Untereinheit",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Kategorien_Untereinheit_Ziel_OrganisationseinheitId",
                        column: x => x.Ziel_OrganisationseinheitId,
                        principalTable: "Untereinheit",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Kategorien_Users_Ziel_ZugewiesenePersonId",
                        column: x => x.Ziel_ZugewiesenePersonId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Kategorien_ZustaendigkeitRollen_Ziel_LiestRolleId",
                        column: x => x.Ziel_LiestRolleId,
                        principalTable: "ZustaendigkeitRollen",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "KategorieAusblendungen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    KategorieId = table.Column<Guid>(type: "uuid", nullable: false),
                    UntereinheitId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_KategorieAusblendungen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KategorieAusblendungen_Kategorien_KategorieId",
                        column: x => x.KategorieId,
                        principalTable: "Kategorien",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KategorieAusblendungen_Untereinheit_UntereinheitId",
                        column: x => x.UntereinheitId,
                        principalTable: "Untereinheit",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_KategorieAusblendungen_KategorieId_UntereinheitId",
                table: "KategorieAusblendungen",
                columns: new[] { "KategorieId", "UntereinheitId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_KategorieAusblendungen_UntereinheitId",
                table: "KategorieAusblendungen",
                column: "UntereinheitId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorien_ParentId",
                table: "Kategorien",
                column: "ParentId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorien_UntereinheitId",
                table: "Kategorien",
                column: "UntereinheitId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorien_Ziel_DienstleisterId",
                table: "Kategorien",
                column: "Ziel_DienstleisterId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorien_Ziel_LiestRolleId",
                table: "Kategorien",
                column: "Ziel_LiestRolleId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorien_Ziel_MitarbeiterGruppeId",
                table: "Kategorien",
                column: "Ziel_MitarbeiterGruppeId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorien_Ziel_OrganisationseinheitId",
                table: "Kategorien",
                column: "Ziel_OrganisationseinheitId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorien_Ziel_ZugewiesenePersonId",
                table: "Kategorien",
                column: "Ziel_ZugewiesenePersonId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "KategorieAusblendungen");

            migrationBuilder.DropTable(
                name: "Kategorien");
        }
    }
}
