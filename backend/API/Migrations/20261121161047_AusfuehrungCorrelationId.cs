using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AusfuehrungCorrelationId : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "CorrelationId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_CorrelationId",
                table: "Ausfuehrungen",
                column: "CorrelationId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_CorrelationId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "CorrelationId",
                table: "Ausfuehrungen");
        }
    }
}
