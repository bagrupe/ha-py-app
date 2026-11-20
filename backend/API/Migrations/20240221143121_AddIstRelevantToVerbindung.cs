using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddIstRelevantToVerbindung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "IstRelevant",
                table: "Verbindungen",
                type: "text",
                nullable: false,
                defaultValue: "true");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "IstRelevant",
                table: "Verbindungen");
        }
    }
}
