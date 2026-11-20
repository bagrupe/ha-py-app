using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddBuergerRegistrationFields : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "Buerger_Nachname",
                table: "Users",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Buerger_Vorname",
                table: "Users",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "CreatedAt",
                table: "Users",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsRegistered",
                table: "Users",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Phone",
                table: "Users",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "PhoneVerified",
                table: "Users",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "RegisteredAt",
                table: "Users",
                type: "timestamp with time zone",
                nullable: true);

            // EF kann NULL nicht in die nicht-nullable bool-Properties materialisieren; daher Backfill für
            // bestehende anonyme Bürger (false ist der zutreffende Wert). CreatedAt bleibt absichtlich NULL.
            migrationBuilder.Sql(
                "UPDATE \"Users\" SET \"IsRegistered\" = false, \"PhoneVerified\" = false WHERE \"Discriminator\" = 'Buerger';");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Buerger_Nachname",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "Buerger_Vorname",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "IsRegistered",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "Phone",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "PhoneVerified",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "RegisteredAt",
                table: "Users");
        }
    }
}
