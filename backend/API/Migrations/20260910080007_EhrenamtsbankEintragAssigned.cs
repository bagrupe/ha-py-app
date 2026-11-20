using API.Features.Ehrenamtsbank;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class EhrenamtsbankEintragAssigned : Migration {
        private static readonly string VereinbarteAnfrageExists = $"""
            EXISTS (
                SELECT 1 FROM "EhrenamtsbankAnfragen" a
                WHERE a."EintragId" = e."Id"
                  AND a."Status" = {(int)EhrenamtsbankAnfrageStatus.Vereinbart}
            )
            """;

        /// <summary>Before Assigned existed, an entry could still be paused or edited after its
        /// Anfrage was agreed, so backfilling from Active alone would miss those rows.</summary>
        private static readonly string PromotableStatus = string.Join(", ", new[] {
            (int)EhrenamtsbankEintragStatus.Active,
            (int)EhrenamtsbankEintragStatus.Paused,
            (int)EhrenamtsbankEintragStatus.PendingReview,
        });

        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql($"""
                UPDATE "EhrenamtsbankEintraege" e
                SET "Status" = {(int)EhrenamtsbankEintragStatus.Assigned}
                WHERE e."Status" IN ({PromotableStatus})
                  AND e."IsDeleted" = false
                  AND {VereinbarteAnfrageExists};
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql($"""
                UPDATE "EhrenamtsbankEintraege" e
                SET "Status" = {(int)EhrenamtsbankEintragStatus.Active}
                WHERE e."Status" = {(int)EhrenamtsbankEintragStatus.Assigned}
                  AND {VereinbarteAnfrageExists};
                """);
        }
    }
}
