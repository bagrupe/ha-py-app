using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddBuergerRequiresClearanceVerified : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<bool>(
                name: "RequiresClearanceVerified",
                table: "Users",
                type: "boolean",
                nullable: true);

            // EF kann NULL nicht in die nicht-nullable bool-Property materialisieren; daher Backfill für
            // bestehende anonyme Bürger (false ist der zutreffende Wert).
            migrationBuilder.Sql(
                "UPDATE \"Users\" SET \"RequiresClearanceVerified\" = false WHERE \"Discriminator\" = 'Buerger';");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "RequiresClearanceVerified",
                table: "Users");
        }
    }
}
