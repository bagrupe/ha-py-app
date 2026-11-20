using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class Add_WarteAufGovmanagerSchritt : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "GovManagerSchrittId",
                table: "Schritte",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "GovManagerRequests",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AusfuehrungId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CompletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    Success = table.Column<bool>(type: "boolean", nullable: true),
                    GovManagerSchrittId = table.Column<Guid>(type: "uuid", nullable: false),
                    ResponseBody = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_GovManagerRequests", x => x.Id);
                    table.ForeignKey(
                        name: "FK_GovManagerRequests_Ausfuehrungen_AusfuehrungId",
                        column: x => x.AusfuehrungId,
                        principalTable: "Ausfuehrungen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_GovManagerRequests_Schritte_GovManagerSchrittId",
                        column: x => x.GovManagerSchrittId,
                        principalTable: "Schritte",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_GovManagerSchrittId",
                table: "Schritte",
                column: "GovManagerSchrittId");

            migrationBuilder.CreateIndex(
                name: "IX_GovManagerRequests_AusfuehrungId",
                table: "GovManagerRequests",
                column: "AusfuehrungId");

            migrationBuilder.CreateIndex(
                name: "IX_GovManagerRequests_GovManagerSchrittId",
                table: "GovManagerRequests",
                column: "GovManagerSchrittId");

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_Schritte_GovManagerSchrittId",
                table: "Schritte",
                column: "GovManagerSchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_Schritte_GovManagerSchrittId",
                table: "Schritte");

            migrationBuilder.DropTable(
                name: "GovManagerRequests");

            migrationBuilder.DropIndex(
                name: "IX_Schritte_GovManagerSchrittId",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "GovManagerSchrittId",
                table: "Schritte");
        }
    }
}
