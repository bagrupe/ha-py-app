using System.Collections.Generic;
using API.Features.Prozess;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class ReplaceStringFormularFeldOptionsWithKeyValue : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Options",
                table: "FormularFelder");
            migrationBuilder.AddColumn<List<StringFormularFeldOption>>(
                name: "Options",
                table: "FormularFelder",
                type: "jsonb",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "Options",
                table: "FormularFelder");
            migrationBuilder.AddColumn<string[]>(
                name: "Options",
                table: "FormularFelder",
                type: "text[]",
                nullable: true);
        }
    }
}
