using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations {
    /// <inheritdoc />
    public partial class AddEhrenamtsbankEintragConcurrencyToken : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            // Bewusst leer. Der Optimistic-Concurrency-Token bildet auf Postgres' System-Spalte
            // "xmin" ab, die auf jeder Tabelle bereits existiert. Ein ADD COLUMN "xmin" lehnt
            // Postgres ab ("conflicts with a system column name"). Npgsql 9 hat das frühere
            // UseXminAsConcurrencyToken entfernt, das dieses DDL sonst unterdrückt hätte; die
            // Konfiguration in EhrenamtsbankEintragConfig genügt zur Laufzeit ohne Migration.
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
        }
    }
}
