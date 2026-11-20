using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddBearbeitungNextSchrittRequired : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Schritte_NextSchrittId",
                table: "Bearbeitungen");

            migrationBuilder.AlterColumn<Guid>(
                name: "NextSchrittId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uuid",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Schritte_NextSchrittId",
                table: "Bearbeitungen",
                column: "NextSchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Schritte_NextSchrittId",
                table: "Bearbeitungen");

            migrationBuilder.AlterColumn<Guid>(
                name: "NextSchrittId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uuid");

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Schritte_NextSchrittId",
                table: "Bearbeitungen",
                column: "NextSchrittId",
                principalTable: "Schritte",
                principalColumn: "Id");
        }
    }
}
