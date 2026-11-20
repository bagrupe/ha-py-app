using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddAbgeschlossenAmToAusfuehrung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Instant>(
                name: "AbgeschlossenAm",
                table: "Ausfuehrungen",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.Sql("""
                UPDATE "Ausfuehrungen"
                SET "AbgeschlossenAm" = "ManuellAbgeschlossen"
                WHERE "ManuellAbgeschlossen" IS NOT NULL;
                """);

            migrationBuilder.Sql("""
                UPDATE "Ausfuehrungen" a
                SET "AbgeschlossenAm" = latest."CreatedAt"
                FROM (
                    SELECT b."AusfuehrungId", MAX(b."CreatedAt") AS "CreatedAt"
                    FROM "Bearbeitungen" b
                    GROUP BY b."AusfuehrungId"
                ) AS latest,
                "Schritte" s
                WHERE a."Id" = latest."AusfuehrungId"
                  AND a."SchrittId" = s."Id"
                  AND a."Status" = 2
                  AND a."ManuellAbgeschlossen" IS NULL
                  AND s."Discriminator" = 'EndeSchritt';
                """);

            migrationBuilder.Sql("""
                UPDATE "Ausfuehrungen"
                SET "AbgeschlossenAm" = "CreatedAt"
                WHERE "Status" = 2
                  AND "AbgeschlossenAm" IS NULL;
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "AbgeschlossenAm",
                table: "Ausfuehrungen");
        }
    }
}
