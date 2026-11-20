using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddZugewiesenePersonToAusfuehrung : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<Guid>(
                name: "ZugewiesenePersonId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                column: "ZugewiesenePersonId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Users_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                column: "ZugewiesenePersonId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Users_ZugewiesenePersonId",
                table: "Ausfuehrungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_ZugewiesenePersonId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "ZugewiesenePersonId",
                table: "Ausfuehrungen");
        }
    }
}
