using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEmailOutboxItem : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "EmailOutboxItems",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false),
                    RecipientEmail = table.Column<string>(type: "text", nullable: false),
                    Subject = table.Column<string>(type: "text", nullable: false),
                    Html = table.Column<string>(type: "text", nullable: false),
                    Text = table.Column<string>(type: "text", nullable: false),
                    NumberOfAttachments = table.Column<int>(type: "integer", nullable: false),
                    FailedDeliveryAttempts = table.Column<int>(type: "integer", nullable: false),
                    FailedAttemptErrorMessage = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_EmailOutboxItems", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "EmailAttachments",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    EmailOutboxItemId = table.Column<Guid>(type: "uuid", nullable: false),
                    MediaType = table.Column<string>(type: "text", nullable: true),
                    Size = table.Column<long>(type: "bigint", nullable: true),
                    Name = table.Column<string>(type: "text", nullable: true),
                    Bytes = table.Column<byte[]>(type: "bytea", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_EmailAttachments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_EmailAttachments_EmailOutboxItems_EmailOutboxItemId",
                        column: x => x.EmailOutboxItemId,
                        principalTable: "EmailOutboxItems",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_EmailAttachments_EmailOutboxItemId",
                table: "EmailAttachments",
                column: "EmailOutboxItemId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "EmailAttachments");

            migrationBuilder.DropTable(
                name: "EmailOutboxItems");
        }
    }
}
