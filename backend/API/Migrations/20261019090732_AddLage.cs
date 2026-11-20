using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddLage : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "Gebiete",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Geometry = table.Column<string>(type: "jsonb", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Gebiete", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Lagen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "text", nullable: false),
                    Note = table.Column<string>(type: "text", nullable: true),
                    WarningText = table.Column<string>(type: "text", nullable: true),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    ActivatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: true),
                    ActivatedById = table.Column<Guid>(type: "uuid", nullable: true),
                    ClosedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: true),
                    ArchivedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: true),
                    DeletedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Lagen", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "LageGebiete",
                columns: table => new {
                    LageId = table.Column<Guid>(type: "uuid", nullable: false),
                    GebietId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_LageGebiete", x => new { x.LageId, x.GebietId });
                    table.ForeignKey(
                        name: "FK_LageGebiete_Gebiete_GebietId",
                        column: x => x.GebietId,
                        principalTable: "Gebiete",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_LageGebiete_Lagen_LageId",
                        column: x => x.LageId,
                        principalTable: "Lagen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Gebiete_KommuneId_Name",
                table: "Gebiete",
                columns: new[] { "KommuneId", "Name" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_LageGebiete_GebietId",
                table: "LageGebiete",
                column: "GebietId");

            migrationBuilder.CreateIndex(
                name: "IX_Lagen_KommuneId",
                table: "Lagen",
                column: "KommuneId");

            migrationBuilder.CreateIndex(
                name: "IX_Lagen_Status",
                table: "Lagen",
                column: "Status");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "LageGebiete");

            migrationBuilder.DropTable(
                name: "Gebiete");

            migrationBuilder.DropTable(
                name: "Lagen");
        }
    }
}
