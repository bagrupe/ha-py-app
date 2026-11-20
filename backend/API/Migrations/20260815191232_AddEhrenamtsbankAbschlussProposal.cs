using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEhrenamtsbankAbschlussProposal : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "ProposedById",
                table: "EhrenamtsbankAnfragen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<LocalDate>(
                name: "ProposedDate",
                table: "EhrenamtsbankAnfragen",
                type: "date",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ProposedMinutes",
                table: "EhrenamtsbankAnfragen",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ProposedNote",
                table: "EhrenamtsbankAnfragen",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "ProposedById",
                table: "EhrenamtsbankAnfragen");

            migrationBuilder.DropColumn(
                name: "ProposedDate",
                table: "EhrenamtsbankAnfragen");

            migrationBuilder.DropColumn(
                name: "ProposedMinutes",
                table: "EhrenamtsbankAnfragen");

            migrationBuilder.DropColumn(
                name: "ProposedNote",
                table: "EhrenamtsbankAnfragen");
        }
    }
}
