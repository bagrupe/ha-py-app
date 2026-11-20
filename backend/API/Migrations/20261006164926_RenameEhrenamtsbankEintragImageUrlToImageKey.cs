using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class RenameEhrenamtsbankEintragImageUrlToImageKey : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.RenameColumn(
                name: "ImageUrl",
                table: "EhrenamtsbankEintraege",
                newName: "ImageKey");

            migrationBuilder.Sql("UPDATE \"EhrenamtsbankEintraege\" SET \"ImageKey\" = NULL;");

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankEintraege_ImageKey",
                table: "EhrenamtsbankEintraege",
                column: "ImageKey",
                unique: true,
                filter: "NOT \"IsDeleted\"");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropIndex(
                name: "IX_EhrenamtsbankEintraege_ImageKey",
                table: "EhrenamtsbankEintraege");

            migrationBuilder.RenameColumn(
                name: "ImageKey",
                table: "EhrenamtsbankEintraege",
                newName: "ImageUrl");
        }
    }
}
