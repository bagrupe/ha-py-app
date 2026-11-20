using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddIstRelevantToFormFields : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_BuergerPersonalData_Users_BuergerId",
                table: "BuergerPersonalData");

            migrationBuilder.AddColumn<string>(
                name: "IstRelevant",
                table: "FormularFelder",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AlterColumn<Guid>(
                name: "BuergerId",
                table: "BuergerPersonalData",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uuid",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_BuergerPersonalData_Users_BuergerId",
                table: "BuergerPersonalData",
                column: "BuergerId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_BuergerPersonalData_Users_BuergerId",
                table: "BuergerPersonalData");

            migrationBuilder.DropColumn(
                name: "IstRelevant",
                table: "FormularFelder");

            migrationBuilder.AlterColumn<Guid>(
                name: "BuergerId",
                table: "BuergerPersonalData",
                type: "uuid",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uuid");

            migrationBuilder.AddForeignKey(
                name: "FK_BuergerPersonalData_Users_BuergerId",
                table: "BuergerPersonalData",
                column: "BuergerId",
                principalTable: "Users",
                principalColumn: "Id");
        }
    }
}
