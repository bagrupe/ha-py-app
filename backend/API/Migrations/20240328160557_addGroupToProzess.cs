using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class addGroupToProzess : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "GroupId",
                table: "UserFacingProzesse",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ProzessGroups",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ProzessGroups", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ProzessGroups_Kommunen_KommuneId",
                        column: x => x.KommuneId,
                        principalTable: "Kommunen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserFacingProzesse_GroupId",
                table: "UserFacingProzesse",
                column: "GroupId");

            migrationBuilder.CreateIndex(
                name: "IX_ProzessGroups_KommuneId",
                table: "ProzessGroups",
                column: "KommuneId");

            migrationBuilder.AddForeignKey(
                name: "FK_UserFacingProzesse_ProzessGroups_GroupId",
                table: "UserFacingProzesse",
                column: "GroupId",
                principalTable: "ProzessGroups",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_UserFacingProzesse_ProzessGroups_GroupId",
                table: "UserFacingProzesse");

            migrationBuilder.DropTable(
                name: "ProzessGroups");

            migrationBuilder.DropIndex(
                name: "IX_UserFacingProzesse_GroupId",
                table: "UserFacingProzesse");

            migrationBuilder.DropColumn(
                name: "GroupId",
                table: "UserFacingProzesse");
        }
    }
}
