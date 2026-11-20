using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class RenameHaPyKommune : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.UpdateData("Kommunen", "Id", Guid.Parse("5a1aefef-809f-403d-a14c-27051353c7d4"), "Name",
                "Landkreis Hameln-Pyrmont");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.UpdateData("Kommunen", "Id", Guid.Parse("5a1aefef-809f-403d-a14c-27051353c7d4"), "Name",
                "Landkreis HaPy");
        }
    }
}
