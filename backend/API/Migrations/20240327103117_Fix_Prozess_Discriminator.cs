using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class Fix_Prozess_Discriminator : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql(
                @"UPDATE ""UserFacingProzesse"" SET ""Discriminator"" = 'Prozess' WHERE ""Discriminator"" = ''");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            // This migration is a one way street.
        }
    }
}
