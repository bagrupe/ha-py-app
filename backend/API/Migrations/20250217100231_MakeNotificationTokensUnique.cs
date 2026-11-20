using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class MakeNotificationTokensUnique : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql($"""
              UPDATE "Users"
              SET "PushNotificationTokens" = array(
                SELECT DISTINCT element FROM UNNEST("PushNotificationTokens") as element
              )
              WHERE "PushNotificationTokens" IS NOT NULL;
            """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {

        }
    }
}
