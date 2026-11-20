using System.Collections.Generic;
using API.Features.GovManager;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddGovManagerRestExportSchritt : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<List<IPart>>(
                name: "ExportParts",
                table: "Schritte",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "MandantenSchluessel",
                table: "Schritte",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "VorgangsSchluessel",
                table: "Schritte",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "VorgangsTyp",
                table: "Schritte",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "ExportParts",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "MandantenSchluessel",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "VorgangsSchluessel",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "VorgangsTyp",
                table: "Schritte");
        }
    }
}
