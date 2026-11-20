using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEhrenamtsbankEintrag : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "EhrenamtsbankEintraege",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Typ = table.Column<int>(type: "integer", nullable: false),
                    OwnerId = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    KategorieId = table.Column<Guid>(type: "uuid", nullable: false),
                    UntereinheitId = table.Column<Guid>(type: "uuid", nullable: false),
                    RadiusKm = table.Column<int>(type: "integer", nullable: true),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    Urgency = table.Column<int>(type: "integer", nullable: true),
                    EstimatedDurationMinutes = table.Column<int>(type: "integer", nullable: true),
                    Availability = table.Column<string>(type: "text", nullable: true),
                    ImageUrl = table.Column<string>(type: "text", nullable: true),
                    Tags = table.Column<List<string>>(type: "text[]", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    ReviewedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_EhrenamtsbankEintraege", x => x.Id);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankEintraege_EhrenamtsbankKategorien_KategorieId",
                        column: x => x.KategorieId,
                        principalTable: "EhrenamtsbankKategorien",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankEintraege_Untereinheit_UntereinheitId",
                        column: x => x.UntereinheitId,
                        principalTable: "Untereinheit",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_EhrenamtsbankEintraege_Users_OwnerId",
                        column: x => x.OwnerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankEintraege_KategorieId",
                table: "EhrenamtsbankEintraege",
                column: "KategorieId");

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankEintraege_OwnerId",
                table: "EhrenamtsbankEintraege",
                column: "OwnerId");

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankEintraege_Status",
                table: "EhrenamtsbankEintraege",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_EhrenamtsbankEintraege_UntereinheitId",
                table: "EhrenamtsbankEintraege",
                column: "UntereinheitId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "EhrenamtsbankEintraege");
        }
    }
}
