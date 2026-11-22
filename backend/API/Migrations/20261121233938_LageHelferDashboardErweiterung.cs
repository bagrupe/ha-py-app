using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class LageHelferDashboardErweiterung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Instant>(
                name: "MeldewegPausiertSeit",
                table: "Lagen",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "MeldewegPausiertVonId",
                table: "Lagen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<List<string>>(
                name: "Ausruestung",
                table: "Einheiten",
                type: "text[]",
                nullable: false,
                defaultValueSql: "'{}'");

            migrationBuilder.AddColumn<List<string>>(
                name: "BenoetigteAusruestung",
                table: "Ausfuehrungen",
                type: "text[]",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ExternKommentar",
                table: "Ausfuehrungen",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ExterneStelle",
                table: "Ausfuehrungen",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "KlaerungGrund",
                table: "Ausfuehrungen",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Klasse",
                table: "Ausfuehrungen",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "MoeglicherNotfall",
                table: "Ausfuehrungen",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "NotfallPruefung",
                table: "Ausfuehrungen",
                type: "integer",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "MeldewegPausiertSeit",
                table: "Lagen");

            migrationBuilder.DropColumn(
                name: "MeldewegPausiertVonId",
                table: "Lagen");

            migrationBuilder.DropColumn(
                name: "Ausruestung",
                table: "Einheiten");

            migrationBuilder.DropColumn(
                name: "BenoetigteAusruestung",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "ExternKommentar",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "ExterneStelle",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "KlaerungGrund",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "Klasse",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "MoeglicherNotfall",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "NotfallPruefung",
                table: "Ausfuehrungen");
        }
    }
}
