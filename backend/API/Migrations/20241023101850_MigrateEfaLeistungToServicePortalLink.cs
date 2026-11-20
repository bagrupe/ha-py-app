using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class MigrateEfaLeistungToServicePortalLink : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "HtmlSnippet",
                table: "UserFacingProzesse");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "HtmlSnippet",
                table: "UserFacingProzesse",
                type: "text",
                nullable: true);
        }
    }
}
