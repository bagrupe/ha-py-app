using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class RestrictAusfuehrungDeleteToProzessVersionAndSchritt : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_ProzessVersionen_ProzessVersionId",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Schritte_SchrittId",
                table: "Ausfuehrungen");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_ProzessVersionen_ProzessVersionId",
                table: "Ausfuehrungen",
                column: "ProzessVersionId",
                principalTable: "ProzessVersionen",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Schritte_SchrittId",
                table: "Ausfuehrungen",
                column: "SchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_ProzessVersionen_ProzessVersionId",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Schritte_SchrittId",
                table: "Ausfuehrungen");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_ProzessVersionen_ProzessVersionId",
                table: "Ausfuehrungen",
                column: "ProzessVersionId",
                principalTable: "ProzessVersionen",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Schritte_SchrittId",
                table: "Ausfuehrungen",
                column: "SchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
