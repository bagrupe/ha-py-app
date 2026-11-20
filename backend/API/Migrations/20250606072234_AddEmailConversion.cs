using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEmailConversion : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql("""
                UPDATE "Users" SET "EMail" = LOWER("EMail")
                WHERE "EMail" IS NOT NULL
                """);

            migrationBuilder.Sql("""
                UPDATE "MitarbeiterGruppen" SET "EMailAdresse" = LOWER("EMailAdresse")
                WHERE "EMailAdresse" IS NOT NULL
                """);

            migrationBuilder.Sql("""
                UPDATE "Dienstleister" SET "EMail" = LOWER("EMail")
                WHERE "EMail" IS NOT NULL
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {

        }
    }
}
