using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEhrenamtsbankEintragLocation : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "Address",
                table: "EhrenamtsbankEintraege",
                type: "character varying(250)",
                maxLength: 250,
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "Latitude",
                table: "EhrenamtsbankEintraege",
                type: "double precision",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "Longitude",
                table: "EhrenamtsbankEintraege",
                type: "double precision",
                nullable: true);

            migrationBuilder.AddCheckConstraint(
                name: "CK_EhrenamtsbankEintrag_Latitude_Range",
                table: "EhrenamtsbankEintraege",
                sql: "\"Latitude\" IS NULL OR (\"Latitude\" >= -90 AND \"Latitude\" <= 90)");

            migrationBuilder.AddCheckConstraint(
                name: "CK_EhrenamtsbankEintrag_Location_Complete",
                table: "EhrenamtsbankEintraege",
                sql: "(\"Address\" IS NULL AND \"Latitude\" IS NULL AND \"Longitude\" IS NULL)\nOR (\"Address\" IS NOT NULL AND \"Latitude\" IS NOT NULL AND \"Longitude\" IS NOT NULL)");

            migrationBuilder.AddCheckConstraint(
                name: "CK_EhrenamtsbankEintrag_Longitude_Range",
                table: "EhrenamtsbankEintraege",
                sql: "\"Longitude\" IS NULL OR (\"Longitude\" >= -180 AND \"Longitude\" <= 180)");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropCheckConstraint(
                name: "CK_EhrenamtsbankEintrag_Latitude_Range",
                table: "EhrenamtsbankEintraege");

            migrationBuilder.DropCheckConstraint(
                name: "CK_EhrenamtsbankEintrag_Location_Complete",
                table: "EhrenamtsbankEintraege");

            migrationBuilder.DropCheckConstraint(
                name: "CK_EhrenamtsbankEintrag_Longitude_Range",
                table: "EhrenamtsbankEintraege");

            migrationBuilder.DropColumn(
                name: "Address",
                table: "EhrenamtsbankEintraege");

            migrationBuilder.DropColumn(
                name: "Latitude",
                table: "EhrenamtsbankEintraege");

            migrationBuilder.DropColumn(
                name: "Longitude",
                table: "EhrenamtsbankEintraege");
        }
    }
}
