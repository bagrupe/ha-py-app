using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddBuergerKeyEscrow : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "BuergerKeyEscrows",
                columns: table => new {
                    BuergerId = table.Column<Guid>(type: "uuid", nullable: false),
                    EncryptedPrivateKey = table.Column<byte[]>(type: "bytea", nullable: false),
                    KeyVersion = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    RetrievalWindowStart = table.Column<Instant>(type: "timestamp with time zone", nullable: true),
                    RetrievalCount = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_BuergerKeyEscrows", x => x.BuergerId);
                    table.ForeignKey(
                        name: "FK_BuergerKeyEscrows_Users_BuergerId",
                        column: x => x.BuergerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "BuergerKeyEscrows");
        }
    }
}
