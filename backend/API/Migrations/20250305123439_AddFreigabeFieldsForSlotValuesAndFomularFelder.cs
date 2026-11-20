using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddFreigabeFieldsForSlotValuesAndFomularFelder : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<bool>(
                name: "IstFreigegeben",
                table: "SlotValues",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "BrauchtFreigabe",
                table: "FormularFelder",
                type: "boolean",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "IstFreigegeben",
                table: "SlotValues");

            migrationBuilder.DropColumn(
                name: "BrauchtFreigabe",
                table: "FormularFelder");
        }
    }
}
