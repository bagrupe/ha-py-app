using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class addBereichBFields : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql("UPDATE \"Users\" SET \"Discriminator\" = 'BackofficeUser' WHERE \"Discriminator\" IN ('Sachbearbeiter', 'Hauptverwaltungsbeamter');");

            migrationBuilder.AlterColumn<string>(
                name: "Discriminator",
                table: "Users",
                type: "character varying(21)",
                maxLength: 21,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(34)",
                oldMaxLength: 34);

            migrationBuilder.AddColumn<bool>(
                name: "IsSyncedToBereichB",
                table: "Users",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "isKommuneAdmin",
                table: "Users",
                type: "boolean",
                nullable: true);

            migrationBuilder.Sql("UPDATE \"Users\" SET \"isKommuneAdmin\" = true WHERE \"EMail\" IN (" +
                                 "'teamleiter-rh@example.com'," +
                                 " 'teamleiter-hapy@example.com'," +
                                 " 'sachbearbeiter-rh@example.com'," +
                                 " 'sachbearbeiter-hapy@example.com');");

            migrationBuilder.AddColumn<string>(
                name: "BereichBId",
                table: "Kommunen",
                type: "text",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Untereinheit",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    IsSyncedToBereichB = table.Column<bool>(type: "boolean", nullable: false),
                    MarkedForDelete = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Untereinheit", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Untereinheit_Kommunen_KommuneId",
                        column: x => x.KommuneId,
                        principalTable: "Kommunen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UntereinheitPermissions",
                columns: table => new {
                    UntereinheitId = table.Column<Guid>(type: "uuid", nullable: false),
                    BackofficeUserId = table.Column<Guid>(type: "uuid", nullable: false),
                    CanEditNews = table.Column<bool>(type: "boolean", nullable: false),
                    CanEditVeranstaltungen = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_UntereinheitPermissions", x => new { x.UntereinheitId, x.BackofficeUserId });
                    table.ForeignKey(
                        name: "FK_UntereinheitPermissions_Untereinheit_UntereinheitId",
                        column: x => x.UntereinheitId,
                        principalTable: "Untereinheit",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UntereinheitPermissions_Users_BackofficeUserId",
                        column: x => x.BackofficeUserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Untereinheit_KommuneId",
                table: "Untereinheit",
                column: "KommuneId");

            migrationBuilder.CreateIndex(
                name: "IX_UntereinheitPermissions_BackofficeUserId",
                table: "UntereinheitPermissions",
                column: "BackofficeUserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "UntereinheitPermissions");

            migrationBuilder.DropTable(
                name: "Untereinheit");

            migrationBuilder.DropColumn(
                name: "IsSyncedToBereichB",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "isKommuneAdmin",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "BereichBId",
                table: "Kommunen");

            migrationBuilder.AlterColumn<string>(
                name: "Discriminator",
                table: "Users",
                type: "character varying(34)",
                maxLength: 34,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(21)",
                oldMaxLength: 21);

            // This is inaccurate but we don't have a way of recovering the information of the specific group after migrating.
            migrationBuilder.Sql("UPDATE \"Users\" SET \"Discriminator\" = 'Sachbearbeiter' WHERE \"Discriminator\" = 'BackofficeUser';");
        }
    }
}
