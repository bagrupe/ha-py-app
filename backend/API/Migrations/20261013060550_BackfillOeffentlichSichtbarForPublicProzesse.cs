using API.Features.Prozess;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class BackfillOeffentlichSichtbarForPublicProzesse : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.Sql(OeffentlichSichtbarBackfill.Sql);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            // Intentionally a no-op: an inverse UPDATE would also clear flags editors set after the backfill.
        }
    }
}
