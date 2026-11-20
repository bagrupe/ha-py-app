using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class UpdateDienstleister : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "BackofficeUserDienstleister");

            migrationBuilder.AddColumn<Guid>(
                name: "DienstleisterId",
                table: "Users",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_DienstleisterId",
                table: "Users",
                column: "DienstleisterId");

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Dienstleister_DienstleisterId",
                table: "Users",
                column: "DienstleisterId",
                principalTable: "Dienstleister",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_Dienstleister_DienstleisterId",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_Users_DienstleisterId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "DienstleisterId",
                table: "Users");

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

            migrationBuilder.CreateIndex(
                name: "IX_BackofficeUserDienstleister_MitarbeiterId",
                table: "BackofficeUserDienstleister",
                column: "MitarbeiterId");
        }
    }
}
