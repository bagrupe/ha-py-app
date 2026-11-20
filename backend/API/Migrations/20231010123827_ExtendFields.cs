using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class ExtendFields : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<bool>(
                name: "Multi",
                table: "FormularFelder",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Multiline",
                table: "FormularFelder",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<string[]>(
                name: "Options",
                table: "FormularFelder",
                type: "text[]",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Multi",
                table: "FormularFelder");

            migrationBuilder.DropColumn(
                name: "Multiline",
                table: "FormularFelder");

            migrationBuilder.DropColumn(
                name: "Options",
                table: "FormularFelder");
        }
    }
}
