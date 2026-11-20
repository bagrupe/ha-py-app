using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class Add_CheckboxListField : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "CheckboxListFeldOptionen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false),
                    Label = table.Column<string>(type: "text", nullable: false),
                    Order = table.Column<int>(type: "integer", nullable: false),
                    DefaultChecked = table.Column<bool>(type: "boolean", nullable: false),
                    FeldId = table.Column<Guid>(type: "uuid", nullable: false)
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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "CheckboxListFeldOptionen");
        }
    }
}
