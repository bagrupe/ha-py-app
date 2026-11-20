using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class Add_Buerger_Personal_Data : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "PersonalDataKeyEncryptedForBuerger",
                table: "Users",
                type: "text",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "BuergerPersonalData",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false),
                    Value = table.Column<string>(type: "text", nullable: false),
                    BuergerId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_BuergerPersonalData", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BuergerPersonalData_Users_BuergerId",
                        column: x => x.BuergerId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_BuergerPersonalData_BuergerId",
                table: "BuergerPersonalData",
                column: "BuergerId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "BuergerPersonalData");

            migrationBuilder.DropColumn(
                name: "PersonalDataKeyEncryptedForBuerger",
                table: "Users");
        }
    }
}
