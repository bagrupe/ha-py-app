using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AusfuehrungFolgen : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "AusfuehrungBuerger",
                columns: table => new {
                    FollowersId = table.Column<Guid>(type: "uuid", nullable: false),
                    GefolgteAusfuehrungenId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_AusfuehrungBuerger", x => new { x.FollowersId, x.GefolgteAusfuehrungenId });
                    table.ForeignKey(
                        name: "FK_AusfuehrungBuerger_Ausfuehrungen_GefolgteAusfuehrungenId",
                        column: x => x.GefolgteAusfuehrungenId,
                        principalTable: "Ausfuehrungen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AusfuehrungBuerger_Users_FollowersId",
                        column: x => x.FollowersId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AusfuehrungBuerger_GefolgteAusfuehrungenId",
                table: "AusfuehrungBuerger",
                column: "GefolgteAusfuehrungenId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "AusfuehrungBuerger");
        }
    }
}
