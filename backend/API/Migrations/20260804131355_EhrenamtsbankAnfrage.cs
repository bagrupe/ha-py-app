using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class EhrenamtsbankAnfrage : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "EhrenamtsbankAnfragen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    EintragId = table.Column<Guid>(type: "uuid", nullable: false),
                    InteressentId = table.Column<Guid>(type: "uuid", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_EhrenamtsbankAnfragen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankAnfragen_EhrenamtsbankEintraege_EintragId",
                        column: x => x.EintragId,
                        principalTable: "EhrenamtsbankEintraege",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankAnfragen_Users_InteressentId",
                        column: x => x.InteressentId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankAnfragen_EintragId_InteressentId",
                table: "EhrenamtsbankAnfragen",
                columns: new[] { "EintragId", "InteressentId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankAnfragen_InteressentId",
                table: "EhrenamtsbankAnfragen",
                column: "InteressentId");

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankAnfragen_Status",
                table: "EhrenamtsbankAnfragen",
                column: "Status");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "EhrenamtsbankAnfragen");
        }
    }
}
