using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddBearbeitungNextSchritt : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "NextSchrittId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_NextSchrittId",
                table: "Bearbeitungen",
                column: "NextSchrittId");

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Schritte_NextSchrittId",
                table: "Bearbeitungen",
                column: "NextSchrittId",
                principalTable: "Schritte",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Schritte_NextSchrittId",
                table: "Bearbeitungen");

            migrationBuilder.DropIndex(
                name: "IX_Bearbeitungen_NextSchrittId",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "NextSchrittId",
                table: "Bearbeitungen");
        }
    }
}
