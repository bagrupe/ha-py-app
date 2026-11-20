using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddPaymentFields : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "BezahlenSchrittId",
                table: "Schritte",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "PaymentRequests",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AusfuehrungId = table.Column<Guid>(type: "uuid", nullable: false),
                    BezahlenSchrittId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CompletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    Success = table.Column<bool>(type: "boolean", nullable: true),
                    PaymentMethod = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_PaymentRequests", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PaymentRequests_Ausfuehrungen_AusfuehrungId",
                        column: x => x.AusfuehrungId,
                        principalTable: "Ausfuehrungen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PaymentRequests_Schritte_BezahlenSchrittId",
                        column: x => x.BezahlenSchrittId,
                        principalTable: "Schritte",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_BezahlenSchrittId",
                table: "Schritte",
                column: "BezahlenSchrittId");

            migrationBuilder.CreateIndex(
                name: "IX_PaymentRequests_AusfuehrungId",
                table: "PaymentRequests",
                column: "AusfuehrungId");

            migrationBuilder.CreateIndex(
                name: "IX_PaymentRequests_BezahlenSchrittId",
                table: "PaymentRequests",
                column: "BezahlenSchrittId");

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_Schritte_BezahlenSchrittId",
                table: "Schritte",
                column: "BezahlenSchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_Schritte_BezahlenSchrittId",
                table: "Schritte");

            migrationBuilder.DropTable(
                name: "PaymentRequests");

            migrationBuilder.DropIndex(
                name: "IX_Schritte_BezahlenSchrittId",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "BezahlenSchrittId",
                table: "Schritte");
        }
    }
}
