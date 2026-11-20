using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class ChangeBearbeitungenToIncludeTheTakenVerbindung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Schritte_NextSchrittId",
                table: "Bearbeitungen");

            migrationBuilder.RenameColumn(
                name: "NextSchrittId",
                table: "Bearbeitungen",
                newName: "SchrittId");

            migrationBuilder.RenameIndex(
                name: "IX_Bearbeitungen_NextSchrittId",
                table: "Bearbeitungen",
                newName: "IX_Bearbeitungen_SchrittId");

            migrationBuilder.AddColumn<Guid>(
                name: "NextVerbindungId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_NextVerbindungId",
                table: "Bearbeitungen",
                column: "NextVerbindungId");

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Schritte_SchrittId",
                table: "Bearbeitungen",
                column: "SchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Verbindungen_NextVerbindungId",
                table: "Bearbeitungen",
                column: "NextVerbindungId",
                principalTable: "Verbindungen",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Schritte_SchrittId",
                table: "Bearbeitungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Verbindungen_NextVerbindungId",
                table: "Bearbeitungen");

            migrationBuilder.DropIndex(
                name: "IX_Bearbeitungen_NextVerbindungId",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "NextVerbindungId",
                table: "Bearbeitungen");

            migrationBuilder.RenameColumn(
                name: "SchrittId",
                table: "Bearbeitungen",
                newName: "NextSchrittId");

            migrationBuilder.RenameIndex(
                name: "IX_Bearbeitungen_SchrittId",
                table: "Bearbeitungen",
                newName: "IX_Bearbeitungen_NextSchrittId");

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Schritte_NextSchrittId",
                table: "Bearbeitungen",
                column: "NextSchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
