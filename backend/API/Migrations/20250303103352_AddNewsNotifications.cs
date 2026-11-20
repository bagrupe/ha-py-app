using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddNewsNotifications : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<List<Guid>>(
                name: "OrganisationseinheitIdsForNewsNotifications",
                table: "Users",
                type: "uuid[]",
                defaultValueSql: "ARRAY[]::uuid[]",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "OrganisationseinheitIdsForNewsNotifications",
                table: "Users");
        }
    }
}
