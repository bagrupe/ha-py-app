using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class LageGebietPerPass : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropPrimaryKey(
                name: "PK_LageGebiete",
                table: "LageGebiete");

            migrationBuilder.AddColumn<Guid>(
                name: "Id",
                table: "LageGebiete",
                type: "uuid",
                nullable: false,
                defaultValueSql: "gen_random_uuid()");

            migrationBuilder.AddColumn<Instant>(
                name: "DoneAt",
                table: "LageGebiete",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DoneById",
                table: "LageGebiete",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_LageGebiete",
                table: "LageGebiete",
                column: "Id");

            migrationBuilder.CreateIndex(
                name: "IX_LageGebiete_LageId_GebietId",
                table: "LageGebiete",
                columns: new[] { "LageId", "GebietId" });

            migrationBuilder.CreateIndex(
                name: "IX_LageGebiete_LageId_GebietId_Open",
                table: "LageGebiete",
                columns: new[] { "LageId", "GebietId" },
                unique: true,
                filter: "\"Status\" IN (0, 1, 2, 3)");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropPrimaryKey(
                name: "PK_LageGebiete",
                table: "LageGebiete");

            migrationBuilder.DropIndex(
                name: "IX_LageGebiete_LageId_GebietId",
                table: "LageGebiete");

            migrationBuilder.DropIndex(
                name: "IX_LageGebiete_LageId_GebietId_Open",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "DoneAt",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "DoneById",
                table: "LageGebiete");

            migrationBuilder.AddPrimaryKey(
                name: "PK_LageGebiete",
                table: "LageGebiete",
                columns: new[] { "LageId", "GebietId" });
        }
    }
}
