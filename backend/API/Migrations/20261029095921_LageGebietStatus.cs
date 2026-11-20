using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class LageGebietStatus : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "ActivatedAt",
                table: "Lagen");

            migrationBuilder.DropIndex(
                name: "IX_Lagen_KommuneId",
                table: "Lagen");

            migrationBuilder.DropIndex(
                name: "IX_Gebiete_KommuneId_Name",
                table: "Gebiete");

            migrationBuilder.DropColumn(
                name: "KommuneId",
                table: "Lagen");

            migrationBuilder.DropColumn(
                name: "KommuneId",
                table: "Gebiete");

            migrationBuilder.AddColumn<Guid>(
                name: "UntereinheitId",
                table: "Lagen",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UntereinheitId",
                table: "Gebiete",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.CreateIndex(
                name: "IX_Lagen_UntereinheitId",
                table: "Lagen",
                column: "UntereinheitId");

            migrationBuilder.CreateIndex(
                name: "IX_Gebiete_UntereinheitId_Name",
                table: "Gebiete",
                columns: new[] { "UntereinheitId", "Name" },
                unique: true);

            migrationBuilder.RenameColumn(
                name: "ActivatedById",
                table: "Lagen",
                newName: "ClosedById");

            migrationBuilder.AddColumn<Instant>(
                name: "CalledOutAt",
                table: "LageGebiete",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "CalledOutById",
                table: "LageGebiete",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "EndedAt",
                table: "LageGebiete",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "EndedById",
                table: "LageGebiete",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "LiveAt",
                table: "LageGebiete",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "LiveById",
                table: "LageGebiete",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Instant>(
                name: "ReadyAt",
                table: "LageGebiete",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "ReadyById",
                table: "LageGebiete",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Status",
                table: "LageGebiete",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddForeignKey(
                name: "FK_Gebiete_Untereinheit_UntereinheitId",
                table: "Gebiete",
                column: "UntereinheitId",
                principalTable: "Untereinheit",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Lagen_Untereinheit_UntereinheitId",
                table: "Lagen",
                column: "UntereinheitId",
                principalTable: "Untereinheit",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Gebiete_Untereinheit_UntereinheitId",
                table: "Gebiete");

            migrationBuilder.DropForeignKey(
                name: "FK_Lagen_Untereinheit_UntereinheitId",
                table: "Lagen");

            migrationBuilder.DropColumn(
                name: "CalledOutAt",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "CalledOutById",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "EndedAt",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "EndedById",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "LiveAt",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "LiveById",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "ReadyAt",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "ReadyById",
                table: "LageGebiete");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "LageGebiete");

            migrationBuilder.DropIndex(
                name: "IX_Lagen_UntereinheitId",
                table: "Lagen");

            migrationBuilder.DropIndex(
                name: "IX_Gebiete_UntereinheitId_Name",
                table: "Gebiete");

            migrationBuilder.DropColumn(
                name: "UntereinheitId",
                table: "Lagen");

            migrationBuilder.DropColumn(
                name: "UntereinheitId",
                table: "Gebiete");

            migrationBuilder.AddColumn<Guid>(
                name: "KommuneId",
                table: "Lagen",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "KommuneId",
                table: "Gebiete",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.RenameColumn(
                name: "ClosedById",
                table: "Lagen",
                newName: "ActivatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Lagen_KommuneId",
                table: "Lagen",
                column: "KommuneId");

            migrationBuilder.CreateIndex(
                name: "IX_Gebiete_KommuneId_Name",
                table: "Gebiete",
                columns: new[] { "KommuneId", "Name" },
                unique: true);

            migrationBuilder.AddColumn<Instant>(
                name: "ActivatedAt",
                table: "Lagen",
                type: "timestamp with time zone",
                nullable: true);
        }
    }
}
