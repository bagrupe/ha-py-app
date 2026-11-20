using System;
using System.Text.Json;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class UnencryptedSlots_LocationFeld_ProzessTags : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.RenameColumn(
                name: "Value",
                table: "SlotValues",
                newName: "EncryptedSlotValue_Value");

            migrationBuilder.AlterColumn<string>(
                name: "EncryptedSlotValue_Value",
                table: "SlotValues",
                oldNullable: false,
                nullable: true);

            migrationBuilder.AddColumn<JsonElement>(
                name: "Value",
                table: "SlotValues",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "SlotValues",
                type: "text",
                nullable: false,
                defaultValue: "EncryptedSlotValue");

            migrationBuilder.AddColumn<bool>(
                name: "Encrypted",
                table: "FormularFelder",
                type: "boolean",
                nullable: false,
                defaultValue: true);

            migrationBuilder.CreateTable(
                name: "ProzessTags",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Tag = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ProzessTags", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ProzessProzessTag",
                columns: table => new {
                    ProzesseId = table.Column<Guid>(type: "uuid", nullable: false),
                    TagsId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ProzessProzessTag", x => new { x.ProzesseId, x.TagsId });
                    table.ForeignKey(
                        name: "FK_ProzessProzessTag_ProzessTags_TagsId",
                        column: x => x.TagsId,
                        principalTable: "ProzessTags",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ProzessProzessTag_Prozesse_ProzesseId",
                        column: x => x.ProzesseId,
                        principalTable: "Prozesse",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ProzessProzessTag_TagsId",
                table: "ProzessProzessTag",
                column: "TagsId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "ProzessProzessTag");

            migrationBuilder.DropTable(
                name: "ProzessTags");

            migrationBuilder.DropColumn(
                name: "Discriminator",
                table: "SlotValues");

            migrationBuilder.DropColumn(
                name: "EncryptedSlotValue_Value",
                table: "SlotValues");

            migrationBuilder.DropColumn(
                name: "Encrypted",
                table: "FormularFelder");

            migrationBuilder.DropColumn(
                name: "Value",
                table: "SlotValues");

            migrationBuilder.RenameColumn(
                name: "EncryptedSlotValue_Value",
                table: "SlotValues",
                newName: "Value");

            migrationBuilder.AlterColumn<string>(
                name: "Value",
                table: "SlotValues",
                oldNullable: true,
                nullable: false);
        }
    }
}
