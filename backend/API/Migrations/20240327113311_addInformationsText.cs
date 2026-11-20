using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class addInformationsText : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "Informationstext",
                table: "Schritte",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Informationstext",
                table: "Schritte");
        }
    }
}
