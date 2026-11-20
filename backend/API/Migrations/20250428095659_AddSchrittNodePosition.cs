using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddSchrittNodePosition : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<double>(
                name: "NodePosition_X",
                table: "Schritte",
                type: "double precision",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "NodePosition_Y",
                table: "Schritte",
                type: "double precision",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "NodePosition_X",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "NodePosition_Y",
                table: "Schritte");
        }
    }
}
