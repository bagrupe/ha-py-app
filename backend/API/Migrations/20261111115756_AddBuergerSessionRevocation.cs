using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddBuergerSessionRevocation : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<int>(
                name: "SessionStamp",
                table: "Users",
                type: "integer",
                nullable: true,
                defaultValue: 0);

            migrationBuilder.AddColumn<Instant>(
                name: "SessionsEndedAt",
                table: "Users",
                type: "timestamp with time zone",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "SessionStamp",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "SessionsEndedAt",
                table: "Users");
        }
    }
}
