using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    public partial class HardenSmsVerification : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<int>(
                name: "VerificationCodeFailedAttempts",
                table: "Users",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "VerificationCodeLockedUntil",
                table: "Users",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "VerificationCodeRequestedAt",
                table: "Users",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "VerificationPhoneHash",
                table: "Users",
                type: "text",
                nullable: true);

            migrationBuilder.Sql(
                "UPDATE \"Users\" SET \"VerificationCodeFailedAttempts\" = 0 WHERE \"Discriminator\" = 'Buerger';");
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "VerificationCodeFailedAttempts",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "VerificationCodeLockedUntil",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "VerificationCodeRequestedAt",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "VerificationPhoneHash",
                table: "Users");
        }
    }
}
