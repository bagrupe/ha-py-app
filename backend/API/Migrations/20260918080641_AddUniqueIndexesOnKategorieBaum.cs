using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddUniqueIndexesOnKategorieBaum : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql(
                "CREATE UNIQUE INDEX \"IX_Kategorien_UntereinheitId_IstWurzel\" " +
                "ON \"Kategorien\" (\"UntereinheitId\") WHERE \"IstWurzel\";");

            migrationBuilder.Sql(
                "CREATE UNIQUE INDEX \"IX_Kategorien_ParentId_UntereinheitId_Name\" " +
                "ON \"Kategorien\" (\"ParentId\", \"UntereinheitId\", \"Name\") NULLS NOT DISTINCT;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql("DROP INDEX \"IX_Kategorien_UntereinheitId_IstWurzel\";");
            migrationBuilder.Sql("DROP INDEX \"IX_Kategorien_ParentId_UntereinheitId_Name\";");
        }
    }
}
