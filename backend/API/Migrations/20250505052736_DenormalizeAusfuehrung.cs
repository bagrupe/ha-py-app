using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class DenormalizeAusfuehrung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "SchrittId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<int>(
                name: "Status",
                table: "Ausfuehrungen",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.Sql(@"
                UPDATE ""Ausfuehrungen"" a
                SET ""SchrittId"" = latest.""NachId""
                FROM (
                    SELECT b1.""AusfuehrungId"", v.""NachId""
                    FROM ""Bearbeitungen"" b1
                    JOIN ""Verbindungen"" v ON b1.""NextVerbindungId"" = v.""Id""
                    WHERE b1.""CreatedAt"" = (
                        SELECT MAX(b2.""CreatedAt"")
                        FROM ""Bearbeitungen"" b2
                        WHERE b2.""AusfuehrungId"" = b1.""AusfuehrungId""
                    )
                ) AS latest
                WHERE a.""Id"" = latest.""AusfuehrungId"";
            ");

            migrationBuilder.Sql(@"
                UPDATE ""Ausfuehrungen"" a
                SET ""Status"" = CASE
                    WHEN a.""ManuellAbgeschlossen"" IS NOT NULL THEN 2
                    WHEN s.""Discriminator"" = 'EndeSchritt' THEN 2
                    WHEN s.""MitarbeiterGruppeId"" IS NOT NULL THEN 1
                    ELSE 0
                END
                FROM ""Schritte"" s
                WHERE a.""SchrittId"" = s.""Id"";
            ");

            migrationBuilder.AlterColumn<Guid>(
                name: "SchrittId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: false,
                defaultValue: null);

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_SchrittId",
                table: "Ausfuehrungen",
                column: "SchrittId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Schritte_SchrittId",
                table: "Ausfuehrungen",
                column: "SchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Schritte_SchrittId",
                table: "Ausfuehrungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_SchrittId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "SchrittId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "Ausfuehrungen");
        }
    }
}
