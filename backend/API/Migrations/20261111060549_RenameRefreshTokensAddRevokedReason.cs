using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class RenameRefreshTokensAddRevokedReason : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_BundIdRefreshTokens_Users_BuergerId",
                table: "BundIdRefreshTokens");

            migrationBuilder.DropPrimaryKey(
                name: "PK_BundIdRefreshTokens",
                table: "BundIdRefreshTokens");

            migrationBuilder.RenameTable(
                name: "BundIdRefreshTokens",
                newName: "RefreshTokens");

            migrationBuilder.RenameIndex(
                name: "IX_BundIdRefreshTokens_TokenHash",
                table: "RefreshTokens",
                newName: "IX_RefreshTokens_TokenHash");

            migrationBuilder.RenameIndex(
                name: "IX_BundIdRefreshTokens_BuergerId",
                table: "RefreshTokens",
                newName: "IX_RefreshTokens_BuergerId");

            migrationBuilder.Sql("""ALTER TABLE "RefreshTokens" ALTER COLUMN "Provider" DROP DEFAULT""");

            migrationBuilder.AddColumn<string>(
                name: "RevokedReason",
                table: "RefreshTokens",
                type: "text",
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_RefreshTokens",
                table: "RefreshTokens",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_RefreshTokens_Users_BuergerId",
                table: "RefreshTokens",
                column: "BuergerId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_RefreshTokens_Users_BuergerId",
                table: "RefreshTokens");

            migrationBuilder.DropPrimaryKey(
                name: "PK_RefreshTokens",
                table: "RefreshTokens");

            migrationBuilder.DropColumn(
                name: "RevokedReason",
                table: "RefreshTokens");

            migrationBuilder.Sql("""ALTER TABLE "RefreshTokens" ALTER COLUMN "Provider" SET DEFAULT 'bundid'""");

            migrationBuilder.RenameTable(
                name: "RefreshTokens",
                newName: "BundIdRefreshTokens");

            migrationBuilder.RenameIndex(
                name: "IX_RefreshTokens_TokenHash",
                table: "BundIdRefreshTokens",
                newName: "IX_BundIdRefreshTokens_TokenHash");

            migrationBuilder.RenameIndex(
                name: "IX_RefreshTokens_BuergerId",
                table: "BundIdRefreshTokens",
                newName: "IX_BundIdRefreshTokens_BuergerId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_BundIdRefreshTokens",
                table: "BundIdRefreshTokens",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_BundIdRefreshTokens_Users_BuergerId",
                table: "BundIdRefreshTokens",
                column: "BuergerId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
