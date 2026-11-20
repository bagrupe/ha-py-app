using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddZustaendigkeitRollen : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
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

            migrationBuilder.RenameColumn(
                name: "AutomatischeZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte",
                newName: "SollZustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameColumn(
                name: "AutomatischeZustaendigkeit_OrganisationseinheitId",
                table: "Schritte",
                newName: "SollZustaendigkeit_OrganisationseinheitId");

            migrationBuilder.RenameColumn(
                name: "AutomatischeZustaendigkeit_MitarbeiterGruppeId",
                table: "Schritte",
                newName: "SollZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameColumn(
                name: "AutomatischeZustaendigkeit_DienstleisterId",
                table: "Schritte",
                newName: "SollZustaendigkeit_DienstleisterId");

            migrationBuilder.RenameColumn(
                name: "AutomatischeZustaendigkeit_Art",
                table: "Schritte",
                newName: "SollZustaendigkeit_Art");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte",
                newName: "IX_Schritte_SollZustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_OrganisationseinheitId",
                table: "Schritte",
                newName: "IX_Schritte_SollZustaendigkeit_OrganisationseinheitId");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_MitarbeiterGruppeId",
                table: "Schritte",
                newName: "IX_Schritte_SollZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_AutomatischeZustaendigkeit_DienstleisterId",
                table: "Schritte",
                newName: "IX_Schritte_SollZustaendigkeit_DienstleisterId");

            migrationBuilder.RenameColumn(
                name: "Zustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                newName: "IstZustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameColumn(
                name: "Zustaendigkeit_OrganisationseinheitId",
                table: "Ausfuehrungen",
                newName: "IstZustaendigkeit_OrganisationseinheitId");

            migrationBuilder.RenameColumn(
                name: "Zustaendigkeit_MitarbeiterGruppeId",
                table: "Ausfuehrungen",
                newName: "IstZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameColumn(
                name: "Zustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen",
                newName: "IstZustaendigkeit_DienstleisterId");

            migrationBuilder.RenameColumn(
                name: "Zustaendigkeit_Art",
                table: "Ausfuehrungen",
                newName: "IstZustaendigkeit_Art");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_IstZustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_OrganisationseinheitId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_IstZustaendigkeit_OrganisationseinheitId");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_MitarbeiterGruppeId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_IstZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_Zustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_IstZustaendigkeit_DienstleisterId");

            migrationBuilder.AddColumn<Guid>(
                name: "SchreibtRolleId",
                table: "Schritte",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "SollZustaendigkeit_LiestRolleId",
                table: "Schritte",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "WarZustaendigkeit_Art",
                table: "Bearbeitungen",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<Guid>(
                name: "WarZustaendigkeit_DienstleisterId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "WarZustaendigkeit_LiestRolleId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "WarZustaendigkeit_MitarbeiterGruppeId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "WarZustaendigkeit_OrganisationseinheitId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "WarZustaendigkeit_ZugewiesenePersonId",
                table: "Bearbeitungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "IstZustaendigkeit_LiestRolleId",
                table: "Ausfuehrungen",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ZustaendigkeitRollen",
                columns: table => new {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    ProzessVersionId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ZustaendigkeitRollen", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ZustaendigkeitRollen_ProzessVersionen_ProzessVersionId",
                        column: x => x.ProzessVersionId,
                        principalTable: "ProzessVersionen",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_SchreibtRolleId",
                table: "Schritte",
                column: "SchreibtRolleId");

            migrationBuilder.CreateIndex(
                name: "IX_Schritte_SollZustaendigkeit_LiestRolleId",
                table: "Schritte",
                column: "SollZustaendigkeit_LiestRolleId");

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_DienstleisterId",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_DienstleisterId");

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_LiestRolleId",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_LiestRolleId");

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_MitarbeiterGruppeId",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_OrganisationseinheitId",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_OrganisationseinheitId");

            migrationBuilder.CreateIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_ZugewiesenePersonId",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.CreateIndex(
                name: "IX_Ausfuehrungen_IstZustaendigkeit_LiestRolleId",
                table: "Ausfuehrungen",
                column: "IstZustaendigkeit_LiestRolleId");

            migrationBuilder.CreateIndex(
                name: "IX_ZustaendigkeitRollen_ProzessVersionId",
                table: "ZustaendigkeitRollen",
                column: "ProzessVersionId");

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Dienstleister_IstZustaendigkeit_Dienstleister~",
                table: "Ausfuehrungen",
                column: "IstZustaendigkeit_DienstleisterId",
                principalTable: "Dienstleister",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_MitarbeiterGruppen_IstZustaendigkeit_Mitarbei~",
                table: "Ausfuehrungen",
                column: "IstZustaendigkeit_MitarbeiterGruppeId",
                principalTable: "MitarbeiterGruppen",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Untereinheit_IstZustaendigkeit_Organisationse~",
                table: "Ausfuehrungen",
                column: "IstZustaendigkeit_OrganisationseinheitId",
                principalTable: "Untereinheit",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_Users_IstZustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                column: "IstZustaendigkeit_ZugewiesenePersonId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Ausfuehrungen_ZustaendigkeitRollen_IstZustaendigkeit_LiestR~",
                table: "Ausfuehrungen",
                column: "IstZustaendigkeit_LiestRolleId",
                principalTable: "ZustaendigkeitRollen",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Dienstleister_WarZustaendigkeit_Dienstleister~",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_DienstleisterId",
                principalTable: "Dienstleister",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_MitarbeiterGruppen_WarZustaendigkeit_Mitarbei~",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_MitarbeiterGruppeId",
                principalTable: "MitarbeiterGruppen",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Untereinheit_WarZustaendigkeit_Organisationse~",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_OrganisationseinheitId",
                principalTable: "Untereinheit",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_Users_WarZustaendigkeit_ZugewiesenePersonId",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_ZugewiesenePersonId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Bearbeitungen_ZustaendigkeitRollen_WarZustaendigkeit_LiestR~",
                table: "Bearbeitungen",
                column: "WarZustaendigkeit_LiestRolleId",
                principalTable: "ZustaendigkeitRollen",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_Dienstleister_SollZustaendigkeit_DienstleisterId",
                table: "Schritte",
                column: "SollZustaendigkeit_DienstleisterId",
                principalTable: "Dienstleister",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_MitarbeiterGruppen_SollZustaendigkeit_MitarbeiterG~",
                table: "Schritte",
                column: "SollZustaendigkeit_MitarbeiterGruppeId",
                principalTable: "MitarbeiterGruppen",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_Untereinheit_SollZustaendigkeit_Organisationseinhe~",
                table: "Schritte",
                column: "SollZustaendigkeit_OrganisationseinheitId",
                principalTable: "Untereinheit",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_Users_SollZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte",
                column: "SollZustaendigkeit_ZugewiesenePersonId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_ZustaendigkeitRollen_SchreibtRolleId",
                table: "Schritte",
                column: "SchreibtRolleId",
                principalTable: "ZustaendigkeitRollen",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Schritte_ZustaendigkeitRollen_SollZustaendigkeit_LiestRolle~",
                table: "Schritte",
                column: "SollZustaendigkeit_LiestRolleId",
                principalTable: "ZustaendigkeitRollen",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Dienstleister_IstZustaendigkeit_Dienstleister~",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_MitarbeiterGruppen_IstZustaendigkeit_Mitarbei~",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Untereinheit_IstZustaendigkeit_Organisationse~",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_Users_IstZustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Ausfuehrungen_ZustaendigkeitRollen_IstZustaendigkeit_LiestR~",
                table: "Ausfuehrungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Dienstleister_WarZustaendigkeit_Dienstleister~",
                table: "Bearbeitungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_MitarbeiterGruppen_WarZustaendigkeit_Mitarbei~",
                table: "Bearbeitungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Untereinheit_WarZustaendigkeit_Organisationse~",
                table: "Bearbeitungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_Users_WarZustaendigkeit_ZugewiesenePersonId",
                table: "Bearbeitungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Bearbeitungen_ZustaendigkeitRollen_WarZustaendigkeit_LiestR~",
                table: "Bearbeitungen");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_Dienstleister_SollZustaendigkeit_DienstleisterId",
                table: "Schritte");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_MitarbeiterGruppen_SollZustaendigkeit_MitarbeiterG~",
                table: "Schritte");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_Untereinheit_SollZustaendigkeit_Organisationseinhe~",
                table: "Schritte");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_Users_SollZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_ZustaendigkeitRollen_SchreibtRolleId",
                table: "Schritte");

            migrationBuilder.DropForeignKey(
                name: "FK_Schritte_ZustaendigkeitRollen_SollZustaendigkeit_LiestRolle~",
                table: "Schritte");

            migrationBuilder.DropTable(
                name: "ZustaendigkeitRollen");

            migrationBuilder.DropIndex(
                name: "IX_Schritte_SchreibtRolleId",
                table: "Schritte");

            migrationBuilder.DropIndex(
                name: "IX_Schritte_SollZustaendigkeit_LiestRolleId",
                table: "Schritte");

            migrationBuilder.DropIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_DienstleisterId",
                table: "Bearbeitungen");

            migrationBuilder.DropIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_LiestRolleId",
                table: "Bearbeitungen");

            migrationBuilder.DropIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_MitarbeiterGruppeId",
                table: "Bearbeitungen");

            migrationBuilder.DropIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_OrganisationseinheitId",
                table: "Bearbeitungen");

            migrationBuilder.DropIndex(
                name: "IX_Bearbeitungen_WarZustaendigkeit_ZugewiesenePersonId",
                table: "Bearbeitungen");

            migrationBuilder.DropIndex(
                name: "IX_Ausfuehrungen_IstZustaendigkeit_LiestRolleId",
                table: "Ausfuehrungen");

            migrationBuilder.DropColumn(
                name: "SchreibtRolleId",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "SollZustaendigkeit_LiestRolleId",
                table: "Schritte");

            migrationBuilder.DropColumn(
                name: "WarZustaendigkeit_Art",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "WarZustaendigkeit_DienstleisterId",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "WarZustaendigkeit_LiestRolleId",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "WarZustaendigkeit_MitarbeiterGruppeId",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "WarZustaendigkeit_OrganisationseinheitId",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "WarZustaendigkeit_ZugewiesenePersonId",
                table: "Bearbeitungen");

            migrationBuilder.DropColumn(
                name: "IstZustaendigkeit_LiestRolleId",
                table: "Ausfuehrungen");

            migrationBuilder.RenameColumn(
                name: "SollZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte",
                newName: "AutomatischeZustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameColumn(
                name: "SollZustaendigkeit_OrganisationseinheitId",
                table: "Schritte",
                newName: "AutomatischeZustaendigkeit_OrganisationseinheitId");

            migrationBuilder.RenameColumn(
                name: "SollZustaendigkeit_MitarbeiterGruppeId",
                table: "Schritte",
                newName: "AutomatischeZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameColumn(
                name: "SollZustaendigkeit_DienstleisterId",
                table: "Schritte",
                newName: "AutomatischeZustaendigkeit_DienstleisterId");

            migrationBuilder.RenameColumn(
                name: "SollZustaendigkeit_Art",
                table: "Schritte",
                newName: "AutomatischeZustaendigkeit_Art");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_SollZustaendigkeit_ZugewiesenePersonId",
                table: "Schritte",
                newName: "IX_Schritte_AutomatischeZustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_SollZustaendigkeit_OrganisationseinheitId",
                table: "Schritte",
                newName: "IX_Schritte_AutomatischeZustaendigkeit_OrganisationseinheitId");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_SollZustaendigkeit_MitarbeiterGruppeId",
                table: "Schritte",
                newName: "IX_Schritte_AutomatischeZustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameIndex(
                name: "IX_Schritte_SollZustaendigkeit_DienstleisterId",
                table: "Schritte",
                newName: "IX_Schritte_AutomatischeZustaendigkeit_DienstleisterId");

            migrationBuilder.RenameColumn(
                name: "IstZustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                newName: "Zustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameColumn(
                name: "IstZustaendigkeit_OrganisationseinheitId",
                table: "Ausfuehrungen",
                newName: "Zustaendigkeit_OrganisationseinheitId");

            migrationBuilder.RenameColumn(
                name: "IstZustaendigkeit_MitarbeiterGruppeId",
                table: "Ausfuehrungen",
                newName: "Zustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameColumn(
                name: "IstZustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen",
                newName: "Zustaendigkeit_DienstleisterId");

            migrationBuilder.RenameColumn(
                name: "IstZustaendigkeit_Art",
                table: "Ausfuehrungen",
                newName: "Zustaendigkeit_Art");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_IstZustaendigkeit_ZugewiesenePersonId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_Zustaendigkeit_ZugewiesenePersonId");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_IstZustaendigkeit_OrganisationseinheitId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_Zustaendigkeit_OrganisationseinheitId");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_IstZustaendigkeit_MitarbeiterGruppeId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_Zustaendigkeit_MitarbeiterGruppeId");

            migrationBuilder.RenameIndex(
                name: "IX_Ausfuehrungen_IstZustaendigkeit_DienstleisterId",
                table: "Ausfuehrungen",
                newName: "IX_Ausfuehrungen_Zustaendigkeit_DienstleisterId");

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
    }
}
