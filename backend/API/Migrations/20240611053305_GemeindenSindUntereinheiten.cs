using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class GemeindenSindUntereinheiten : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<bool>(
                name: "IsGemeinde",
                table: "Untereinheit",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Regionalschluessel",
                table: "Untereinheit",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "IsGemeinde",
                table: "Untereinheit");

            migrationBuilder.DropColumn(
                name: "Regionalschluessel",
                table: "Untereinheit");
        }
    }
}
