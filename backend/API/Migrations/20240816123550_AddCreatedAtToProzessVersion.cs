using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddCreatedAtToProzessVersion : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Instant>(
                name: "CreatedAt",
                table: "ProzessVersionen",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.Sql("UPDATE \"ProzessVersionen\" set \"CreatedAt\" = \"PublishedAt\" where \"CreatedAt\" is null;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "ProzessVersionen");
        }
    }
}
