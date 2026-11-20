using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEhrenamtsbankTransaktion : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "EhrenamtsbankTransaktionen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AnfrageId = table.Column<Guid>(type: "uuid", nullable: false),
                    EintragId = table.Column<Guid>(type: "uuid", nullable: false),
                    GiverId = table.Column<Guid>(type: "uuid", nullable: false),
                    ReceiverId = table.Column<Guid>(type: "uuid", nullable: false),
                    Minutes = table.Column<int>(type: "integer", nullable: false),
                    PerformedOn = table.Column<LocalDate>(type: "date", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    Note = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_EhrenamtsbankTransaktionen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankTransaktionen_EhrenamtsbankAnfragen_AnfrageId",
                        column: x => x.AnfrageId,
                        principalTable: "EhrenamtsbankAnfragen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankTransaktionen_EhrenamtsbankEintraege_EintragId",
                        column: x => x.EintragId,
                        principalTable: "EhrenamtsbankEintraege",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankTransaktionen_Users_GiverId",
                        column: x => x.GiverId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankTransaktionen_Users_ReceiverId",
                        column: x => x.ReceiverId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankTransaktionen_AnfrageId",
                table: "EhrenamtsbankTransaktionen",
                column: "AnfrageId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankTransaktionen_EintragId",
                table: "EhrenamtsbankTransaktionen",
                column: "EintragId");

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankTransaktionen_GiverId",
                table: "EhrenamtsbankTransaktionen",
                column: "GiverId");

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankTransaktionen_ReceiverId",
                table: "EhrenamtsbankTransaktionen",
                column: "ReceiverId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "EhrenamtsbankTransaktionen");
        }
    }
}
