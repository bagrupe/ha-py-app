using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class RemoveFormularPflichtfeld : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Pflichtfeld",
                table: "FormularFelder");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<bool>(
                name: "Pflichtfeld",
                table: "FormularFelder",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }
    }
}
