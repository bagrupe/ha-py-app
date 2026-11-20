using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEMailAdressenListToUntereinheitAndDienstleister : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string[]>(
                name: "EMailAdressen",
                table: "Untereinheit",
                type: "text[]",
                nullable: false,
                defaultValueSql: "'{}'");

            migrationBuilder.AddColumn<string[]>(
                name: "EMailAdressen",
                table: "Dienstleister",
                type: "text[]",
                nullable: false,
                defaultValueSql: "'{}'");

            migrationBuilder.Sql("""
                UPDATE "Untereinheit" SET "EMailAdressen" = ARRAY["EMailAdresse"] WHERE "EMailAdresse" IS NOT NULL AND "EMailAdresse" != '';
            """);

            migrationBuilder.Sql("""
                UPDATE "Dienstleister" SET "EMailAdressen" = ARRAY["EMail"] WHERE "EMail" IS NOT NULL AND "EMail" != '';
            """);

            migrationBuilder.DropColumn(
                name: "EMailAdresse",
                table: "Untereinheit");

            migrationBuilder.DropColumn(
                name: "EMail",
                table: "Dienstleister");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "EMailAdresse",
                table: "Untereinheit",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "EMail",
                table: "Dienstleister",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.Sql("""
                UPDATE "Untereinheit" SET "EMailAdresse" = "EMailAdressen"[1] WHERE array_length("EMailAdressen", 1) > 0;
            """);

            migrationBuilder.Sql("""
                UPDATE "Dienstleister" SET "EMail" = "EMailAdressen"[1] WHERE array_length("EMailAdressen", 1) > 0;
            """);

            migrationBuilder.DropColumn(
                name: "EMailAdressen",
                table: "Untereinheit");

            migrationBuilder.DropColumn(
                name: "EMailAdressen",
                table: "Dienstleister");
        }
    }
}
