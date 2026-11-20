using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NodaTime;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class Initial : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "Kommunen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    PublicKey = table.Column<string>(type: "text", nullable: true),
                    PrivateKey = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Kommunen", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Prozesse",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Prozesse", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Prozesse_Kommunen_KommuneId",
                        column: x => x.KommuneId,
                        principalTable: "Kommunen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    EMail = table.Column<string>(type: "text", nullable: false),
                    Password = table.Column<string>(type: "text", nullable: false),
                    PublicKey = table.Column<string>(type: "text", nullable: true),
                    PersonalPrivateKey = table.Column<string>(type: "text", nullable: true),
                    PersonalPrivateKeySalt = table.Column<string>(type: "text", nullable: true),
                    Discriminator = table.Column<string>(type: "text", nullable: false),
                    OrganisationPrivateKey = table.Column<string>(type: "text", nullable: true),
                    KommuneId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Kommunen_KommuneId",
                        column: x => x.KommuneId,
                        principalTable: "Kommunen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Ausfuehrungen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ProzessVersionId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false),
                    SharedKeyEncryptedForBuerger = table.Column<string>(type: "text", nullable: false),
                    SharedKeyEncryptedForKommune = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Ausfuehrungen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Ausfuehrungen_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Bearbeitungen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AusfuehrungId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Bearbeitungen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Bearbeitungen_Ausfuehrungen_AusfuehrungId",
                        column: x => x.AusfuehrungId,
                        principalTable: "Ausfuehrungen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Bearbeitungen_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "SlotValues",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BearbeitungId = table.Column<Guid>(type: "uuid", nullable: false),
                    SlotName = table.Column<string>(type: "text", nullable: false),
                    Value = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_SlotValues", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SlotValues_Bearbeitungen_BearbeitungId",
                        column: x => x.BearbeitungId,
                        principalTable: "Bearbeitungen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "FormularFelder",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    SlotName = table.Column<string>(type: "text", nullable: false),
                    AngezeigterName = table.Column<string>(type: "text", nullable: true),
                    Pflichtfeld = table.Column<bool>(type: "boolean", nullable: false),
                    Anweisung = table.Column<string>(type: "text", nullable: true),
                    SchrittId = table.Column<Guid>(type: "uuid", nullable: false),
                    Order = table.Column<int>(type: "integer", nullable: false),
                    Discriminator = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_FormularFelder", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ProzessVersionen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    PublishedAt = table.Column<Instant>(type: "timestamp with time zone", nullable: true),
                    ProzessId = table.Column<Guid>(type: "uuid", nullable: false),
                    StartId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ProzessVersionen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ProzessVersionen_Prozesse_ProzessId",
                        column: x => x.ProzessId,
                        principalTable: "Prozesse",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Schritte",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ProzessVersionId = table.Column<Guid>(type: "uuid", nullable: false),
                    ErledigungDurchBuerger = table.Column<bool>(type: "boolean", nullable: false),
                    Titel = table.Column<string>(type: "text", nullable: true),
                    Anweisung = table.Column<string>(type: "text", nullable: true),
                    Discriminator = table.Column<string>(type: "text", nullable: false),
                    Betrag = table.Column<decimal>(type: "numeric", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Schritte", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Schritte_ProzessVersionen_ProzessVersionId",
                        column: x => x.ProzessVersionId,
                        principalTable: "ProzessVersionen",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Slot",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    ValueType = table.Column<int>(type: "integer", nullable: false),
                    SchrittId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Slot", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Slot_Schritte_SchrittId",
                        column: x => x.SchrittId,
                        principalTable: "Schritte",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Verbindungen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    VonId = table.Column<Guid>(type: "uuid", nullable: false),
                    NachId = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Verbindungen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Verbindungen_Schritte_NachId",
                        column: x => x.NachId,
                        principalTable: "Schritte",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Verbindungen_Schritte_VonId",
                        column: x => x.VonId,
                        principalTable: "Schritte",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_ProzessVersionId",
                table: "Ausfuehrungen",
                column: "ProzessVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_UserId",
                table: "Ausfuehrungen",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_AusfuehrungId",
                table: "Bearbeitungen",
                column: "AusfuehrungId");

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_UserId",
                table: "Bearbeitungen",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_FormularFelder_SchrittId",
                table: "FormularFelder",
                column: "SchrittId");

            migrationBuilder.CreateIndex(
                name: "IX_Prozesse_KommuneId",
                table: "Prozesse",
                column: "KommuneId");

            migrationBuilder.CreateIndex(
                name: "IX_ProzessVersionen_ProzessId",
                table: "ProzessVersionen",
                column: "ProzessId");

            migrationBuilder.CreateIndex(
                name: "IX_ProzessVersionen_StartId",
                table: "ProzessVersionen",
                column: "StartId");

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_ProzessVersionId",
                table: "Schritte",
                column: "ProzessVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_Slot_SchrittId",
                table: "Slot",
                column: "SchrittId");

            migrationBuilder.CreateIndex(
                name: "IX_SlotValues_BearbeitungId",
                table: "SlotValues",
                column: "BearbeitungId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_EMail",
                table: "Users",
                column: "EMail",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_KommuneId",
                table: "Users",
                column: "KommuneId");

            migrationBuilder.CreateIndex(
                name: "IX_Verbindungen_NachId",
                table: "Verbindungen",
                column: "NachId");

            migrationBuilder.CreateIndex(
                name: "IX_Verbindungen_VonId",
                table: "Verbindungen",
                column: "VonId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_ProzessVersionen_ProzessVersionId",
                table: "Ausfuehrungen",
                column: "ProzessVersionId",
                principalTable: "ProzessVersionen",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_FormularFelder_Schritte_SchrittId",
                table: "FormularFelder",
                column: "SchrittId",
                principalTable: "Schritte",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ProzessVersionen_Schritte_StartId",
                table: "ProzessVersionen",
                column: "StartId",
                principalTable: "Schritte",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_ProzessVersionen_ProzessVersionId",
                table: "Schritte");

            migrationBuilder.DropTable(
                name: "FormularFelder");

            migrationBuilder.DropTable(
                name: "Slot");

            migrationBuilder.DropTable(
                name: "SlotValues");

            migrationBuilder.DropTable(
                name: "Verbindungen");

            migrationBuilder.DropTable(
                name: "Bearbeitungen");

            migrationBuilder.DropTable(
                name: "Ausfuehrungen");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "ProzessVersionen");

            migrationBuilder.DropTable(
                name: "Prozesse");

            migrationBuilder.DropTable(
                name: "Schritte");

            migrationBuilder.DropTable(
                name: "Kommunen");
        }
    }
}
