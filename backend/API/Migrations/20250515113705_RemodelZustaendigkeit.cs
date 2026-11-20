using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class RemodelZustaendigkeit : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Users_ZugewiesenePersonId",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_MitarbeiterGruppen_MitarbeiterGruppeId",
                table: "Schritte");

            migrationBuilder.RenameColumn(
                name: "MitarbeiterGruppeId",
                table: "Schritte",
                newName: "AutomatischeZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_MitarbeiterGruppeId",
                table: "Schritte",
                newName: "IX_Schritte_AutomatischeZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameColumn(
                name: "ZugewiesenePersonId",
                table: "Ausfuehrungen",
                newName: "Zustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_Zustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.AddColumn<int>(
                name: "AutomatischeZustaendigkeit_Art",
                table: "Schritte",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.Sql($"""
                UPDATE "Schritte"
                SET "AutomatischeZustaendigkeit_Art" = 1
                WHERE "AutomatischeZustaendigkeit_MitarbeiterGruppeId" IS NOT NULL
            """);

            migrationBuilder.AddColumn<Guid>(
                name: "AutomatischeZustaendigkeit_DienstleisterId",
                table: "Schritte",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "AutomatischeZustaendigkeit_OrganisationseinheitId",
                table: "Schritte",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "AutomatischeZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Zustaendigkeit_Art",
                table: "Ausfuehrungen",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<Guid>(
                name: "Zustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "Zustaendigkeit_MitarbeiterGruppeId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "Zustaendigkeit_OrganisationseinheitId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_DienstleisterId",
                table: "Schritte",
                column: "AutomatischeZustaendigkeit_DienstleisterId");

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_OrganisationseinheitId",
                table: "Schritte",
                column: "AutomatischeZustaendigkeit_OrganisationseinheitId");

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte",
                column: "AutomatischeZustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen",
                column: "Zustaendigkeit_DienstleisterId");

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_MitarbeiterGruppeId",
                table: "Ausfuehrungen",
                column: "Zustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_OrganisationseinheitId",
                table: "Ausfuehrungen",
                column: "Zustaendigkeit_OrganisationseinheitId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Dienstleister_Zustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen",
                column: "Zustaendigkeit_DienstleisterId",
                principalTable: "Dienstleister",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_MitarbeiterGruppen_Zustaendigkeit_Mitarbeiter~",
                table: "Ausfuehrungen",
                column: "Zustaendigkeit_MitarbeiterGruppeId",
                principalTable: "MitarbeiterGruppen",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Untereinheit_Zustaendigkeit_Organisationseinh~",
                table: "Ausfuehrungen",
                column: "Zustaendigkeit_OrganisationseinheitId",
                principalTable: "Untereinheit",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Users_Zustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                column: "Zustaendigkeit_ZugewiesenePersonId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_Dienstleister_AutomatischeZustaendigkeit_Dienstlei~",
                table: "Schritte",
                column: "AutomatischeZustaendigkeit_DienstleisterId",
                principalTable: "Dienstleister",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_MitarbeiterGruppen_AutomatischeZustaendigkeit_Mita~",
                table: "Schritte",
                column: "AutomatischeZustaendigkeit_MitarbeiterGruppeId",
                principalTable: "MitarbeiterGruppen",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_Untereinheit_AutomatischeZustaendigkeit_Organisati~",
                table: "Schritte",
                column: "AutomatischeZustaendigkeit_OrganisationseinheitId",
                principalTable: "Untereinheit",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_Users_AutomatischeZustaendigkeit_ZugewiesenePerson~",
                table: "Schritte",
                column: "AutomatischeZustaendigkeit_ZugewiesenePersonId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Dienstleister_Zustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_MitarbeiterGruppen_Zustaendigkeit_Mitarbeiter~",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Untereinheit_Zustaendigkeit_Organisationseinh~",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Users_Zustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_Dienstleister_AutomatischeZustaendigkeit_Dienstlei~",
                table: "Schritte");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_MitarbeiterGruppen_AutomatischeZustaendigkeit_Mita~",
                table: "Schritte");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_Untereinheit_AutomatischeZustaendigkeit_Organisati~",
                table: "Schritte");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_Users_AutomatischeZustaendigkeit_ZugewiesenePerson~",
                table: "Schritte");

            migrationBuilder.DropIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_DienstleisterId",
                table: "Schritte");

            migrationBuilder.DropIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_OrganisationseinheitId",
                table: "Schritte");

            migrationBuilder.DropIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_MitarbeiterGruppeId",
                table: "Ausfuehrungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_OrganisationseinheitId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "AutomatischeZustaendigkeit_Art",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "AutomatischeZustaendigkeit_DienstleisterId",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "AutomatischeZustaendigkeit_OrganisationseinheitId",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "AutomatischeZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "Zustaendigkeit_Art",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "Zustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "Zustaendigkeit_MitarbeiterGruppeId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "Zustaendigkeit_OrganisationseinheitId",
                table: "Ausfuehrungen");

            migrationBuilder.RenameColumn(
                name: "AutomatischeZustaendigkeit_MitarbeiterGruppeId",
                table: "Schritte",
                newName: "MitarbeiterGruppeId");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_MitarbeiterGruppeId",
                table: "Schritte",
                newName: "IX_Schritte_MitarbeiterGruppeId");

            migrationBuilder.RenameColumn(
                name: "Zustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                newName: "ZugewiesenePersonId");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_ZugewiesenePersonId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Users_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                column: "ZugewiesenePersonId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_MitarbeiterGruppen_MitarbeiterGruppeId",
                table: "Schritte",
                column: "MitarbeiterGruppeId",
                principalTable: "MitarbeiterGruppen",
                principalColumn: "Id");
        }
    }
}
