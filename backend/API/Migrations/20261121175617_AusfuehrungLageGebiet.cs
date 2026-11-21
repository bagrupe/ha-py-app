using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AusfuehrungLageGebiet : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "LageGebietId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_LageGebietId",
                table: "Ausfuehrungen",
                column: "LageGebietId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_LageGebiete_LageGebietId",
                table: "Ausfuehrungen",
                column: "LageGebietId",
                principalTable: "LageGebiete",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_LageGebiete_LageGebietId",
                table: "Ausfuehrungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_LageGebietId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "LageGebietId",
                table: "Ausfuehrungen");
        }
    }
}
