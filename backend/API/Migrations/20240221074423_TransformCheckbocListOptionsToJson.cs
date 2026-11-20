using System;
using System.Collections.Generic;
using API.Features.Prozess;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class TransformCheckbocListOptionsToJson : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "CheckboxListFeldOptionen");

            migrationBuilder.AddColumn<List<StringFormularFeldOption>>(
                name: "StringFormularFeld_Options",
                table: "FormularFelder",
                type: "jsonb",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "StringFormularFeld_Options",
                table: "FormularFelder");

            migrationBuilder.CreateTable(
                name: "CheckboxListFeldOptionen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    FeldId = table.Column<Guid>(type: "uuid", nullable: false),
                    DefaultChecked = table.Column<bool>(type: "boolean", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false),
                    Label = table.Column<string>(type: "text", nullable: false),
                    Order = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_CheckboxListFeldOptionen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CheckboxListFeldOptionen_FormularFelder_FeldId",
                        column: x => x.FeldId,
                        principalTable: "FormularFelder",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_CheckboxListFeldOptionen_FeldId",
                table: "CheckboxListFeldOptionen",
                column: "FeldId");
        }
    }
}
