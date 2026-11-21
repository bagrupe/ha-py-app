using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class UploadFormularFeldMaxAnzahl : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<int>(
                name: "MaxAnzahl",
                table: "FormularFelder",
                type: "integer",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "MaxAnzahl",
                table: "FormularFelder");
        }
    }
}
