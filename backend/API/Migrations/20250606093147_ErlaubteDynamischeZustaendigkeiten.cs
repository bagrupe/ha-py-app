using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class ErlaubteDynamischeZustaendigkeiten : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<int[]>(
                name: "SollZustaendigkeit_DynamischeArten",
                table: "Schritte",
                type: "integer[]",
                nullable: false,
                defaultValue: new int[0]);
            migrationBuilder.Sql("""
                                 UPDATE "Schritte" SET "SollZustaendigkeit_DynamischeArten" = '{1, 2}'
                                 WHERE "SollZustaendigkeit_Art" = 3;
                                 """);
            migrationBuilder.AddColumn<int[]>(
                name: "WarZustaendigkeit_DynamischeArten",
                table: "Bearbeitungen",
                type: "integer[]",
                nullable: false,
                defaultValue: new int[0]);

            migrationBuilder.AddColumn<int[]>(
                name: "IstZustaendigkeit_DynamischeArten",
                table: "Ausfuehrungen",
                type: "integer[]",
                nullable: false,
                defaultValue: new int[0]);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "SollZustaendigkeit_DynamischeArten",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "WarZustaendigkeit_DynamischeArten",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "IstZustaendigkeit_DynamischeArten",
                table: "Ausfuehrungen");
        }
    }
}
