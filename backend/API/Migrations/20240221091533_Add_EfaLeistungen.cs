using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class Add_EfaLeistungen : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Prozesse_Kommunen_KommuneId",
                table: "Prozesse");

            migrationBuilder.DropForeignKey(
                name: "FK_ProzessProzessTag_Prozesse_ProzesseId",
                table: "ProzessProzessTag");

            migrationBuilder.DropForeignKey(
                name: "FK_ProzessVersionen_Prozesse_ProzessId",
                table: "ProzessVersionen");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Prozesse",
                table: "Prozesse");

            migrationBuilder.RenameTable(
                name: "Prozesse",
                newName: "UserFacingProzesse");

            migrationBuilder.RenameIndex(
                name: "IX_Prozesse_KommuneId",
                table: "UserFacingProzesse",
                newName: "IX_UserFacingProzesse_KommuneId");

            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "UserFacingProzesse",
                type: "character varying(21)",
                maxLength: 21,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "HtmlSnippet",
                table: "UserFacingProzesse",
                type: "text",
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_UserFacingProzesse",
                table: "UserFacingProzesse",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ProzessProzessTag_UserFacingProzesse_ProzesseId",
                table: "ProzessProzessTag",
                column: "ProzesseId",
                principalTable: "UserFacingProzesse",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ProzessVersionen_UserFacingProzesse_ProzessId",
                table: "ProzessVersionen",
                column: "ProzessId",
                principalTable: "UserFacingProzesse",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserFacingProzesse_Kommunen_KommuneId",
                table: "UserFacingProzesse",
                column: "KommuneId",
                principalTable: "Kommunen",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_ProzessProzessTag_UserFacingProzesse_ProzesseId",
                table: "ProzessProzessTag");

            migrationBuilder.DropForeignKey(
                name: "FK_ProzessVersionen_UserFacingProzesse_ProzessId",
                table: "ProzessVersionen");

            migrationBuilder.DropForeignKey(
                name: "FK_UserFacingProzesse_Kommunen_KommuneId",
                table: "UserFacingProzesse");

            migrationBuilder.DropPrimaryKey(
                name: "PK_UserFacingProzesse",
                table: "UserFacingProzesse");

            migrationBuilder.DropColumn(
                name: "Discriminator",
                table: "UserFacingProzesse");

            migrationBuilder.DropColumn(
                name: "HtmlSnippet",
                table: "UserFacingProzesse");

            migrationBuilder.RenameTable(
                name: "UserFacingProzesse",
                newName: "Prozesse");

            migrationBuilder.RenameIndex(
                name: "IX_UserFacingProzesse_KommuneId",
                table: "Prozesse",
                newName: "IX_Prozesse_KommuneId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Prozesse",
                table: "Prozesse",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Prozesse_Kommunen_KommuneId",
                table: "Prozesse",
                column: "KommuneId",
                principalTable: "Kommunen",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ProzessProzessTag_Prozesse_ProzesseId",
                table: "ProzessProzessTag",
                column: "ProzesseId",
                principalTable: "Prozesse",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ProzessVersionen_Prozesse_ProzessId",
                table: "ProzessVersionen",
                column: "ProzessId",
                principalTable: "Prozesse",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
