using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEMailAdressenListToMitarbeiterGruppen : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string[]>(
                name: "EMailAdressen",
                table: "MitarbeiterGruppen",
                type: "text[]",
                nullable: false,
                defaultValueSql: "'{}'");

            migrationBuilder.Sql("""
                UPDATE "MitarbeiterGruppen" SET "EMailAdressen" = ARRAY["EMailAdresse"] WHERE "EMailAdresse" IS NOT NULL AND "EMailAdresse" != '';
            """);

            migrationBuilder.DropColumn(
                name: "EMailAdresse",
                table: "MitarbeiterGruppen");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "EMailAdresse",
                table: "MitarbeiterGruppen",
                type: "text",
                nullable: true);

            migrationBuilder.Sql("""
                UPDATE "MitarbeiterGruppen" SET "EMailAdresse" = "EMailAdressen"[1] WHERE array_length("EMailAdressen", 1) > 0;
            """);

            migrationBuilder.DropColumn(
                name: "EMailAdressen",
                table: "MitarbeiterGruppen");
        }
    }
}
