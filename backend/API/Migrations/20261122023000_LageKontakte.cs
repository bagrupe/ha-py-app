using Microsoft.EntityFrameworkCore.Migrations;

namespace API.Migrations;

public partial class LageKontakte : Migration {
    protected override void Up(MigrationBuilder migrationBuilder) => migrationBuilder.Sql("""
        CREATE TABLE "LageKontakte" (
            "Id" uuid PRIMARY KEY,
            "LageId" uuid NOT NULL REFERENCES "Lagen" ("Id") ON DELETE CASCADE,
            "MeldungId" uuid NULL,
            "Telefonnummer" varchar(40) NOT NULL,
            "Rueckruf" boolean NOT NULL,
            "Erstellt" timestamptz NOT NULL,
            "Erledigt" timestamptz NULL
        );
        CREATE INDEX "IX_LageKontakte_LageId" ON "LageKontakte" ("LageId");
        """);

    protected override void Down(MigrationBuilder migrationBuilder) => migrationBuilder.DropTable("LageKontakte");
}
