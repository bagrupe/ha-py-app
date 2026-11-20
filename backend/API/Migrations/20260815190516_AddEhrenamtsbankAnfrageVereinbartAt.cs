using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEhrenamtsbankAnfrageVereinbartAt : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Instant>(
                name: "VereinbartAt",
                table: "EhrenamtsbankAnfragen",
                type: "timestamp with time zone",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "VereinbartAt",
                table: "EhrenamtsbankAnfragen");
        }
    }
}
