using System.Reflection;
using API.Features.Auth;
using API.Features.Dienstleistungen;
using API.Features.Email;
using API.Features.EmailForwarder;
using API.Features.Expressions;
using API.Features.GovManager;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.DataProtection.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace API.Features;

/// <summary>Stellt den Datenbankkontext für die Domäne der Kommunal-App bereit.</summary>
public class DomainContext : DbContext, IDataProtectionKeyContext {
    private readonly IDataProtectionProvider _dataProtectionProvider;

    /// <summary>Initialisiert eine neue Instanz des DomainContext mit den angegebenen Optionen.</summary>
    /// <param name="options">Die Optionen für den DbContext.</param>
    public DomainContext(DbContextOptions<DomainContext> options, IDataProtectionProvider dataProtectionProvider) : base(options) {
        _dataProtectionProvider = dataProtectionProvider;
    }

    public DbSet<Kommune.Kommune> Kommunen { get; set; } = null!;
    public DbSet<Prozess.UserFacingProzess> UserFacingProzesse { get; set; } = null!;
    public DbSet<Prozess.Prozess> Prozesse { get; set; } = null!;
    public DbSet<Prozess.ServicePortalLink> ServicePortalLink { get; set; } = null!;
    public DbSet<Prozess.ProzessTag> ProzessTags { get; set; } = null!;
    public DbSet<Prozess.ProzessTagHistorieEintrag> ProzessTagHistorie { get; set; } = null!;
    public DbSet<Prozess.ProzessVersion> ProzessVersionen { get; set; } = null!;
    public DbSet<Prozess.ProzessGroup> ProzessGroups { get; set; } = null!;
    public DbSet<Prozess.Ausfuehrung> Ausfuehrungen { get; set; } = null!;
    public DbSet<Prozess.Bearbeitung> Bearbeitungen { get; set; } = null!;
    public DbSet<Prozess.VerlaufsEintrag> VerlaufsEintraege { get; set; } = null!;
    public DbSet<Prozess.SlotValue> SlotValues { get; set; } = null!;
    public DbSet<Prozess.EncryptedSlotValue> EncryptedSlotValues { get; set; } = null!;
    public DbSet<Prozess.PlainSlotValue> PlainSlotValues { get; set; } = null!;
    public DbSet<User> Users { get; set; } = null!;
    public DbSet<Mitarbeiter> Mitarbeiter { get; set; } = null!;
    public DbSet<MitarbeiterGruppe> MitarbeiterGruppen { get; set; } = null!;
    public DbSet<BackofficeUser> BackofficeUser { get; set; } = null!;
    public DbSet<Untereinheit.Untereinheit> Untereinheit { get; set; } = null!;
    public DbSet<Untereinheit.UntereinheitPermissions> UntereinheitPermissions { get; set; } = null!;
    public DbSet<Buerger> Buerger { get; set; } = null!;
    public DbSet<SystemUser> SystemUsers { get; set; } = null!;
    public DbSet<Auth.BundId.ExternalIdentity> ExternalIdentities { get; set; } = null!;
    public DbSet<Auth.RefreshTokens.RefreshToken> RefreshTokens { get; set; } = null!;
    public DbSet<Auth.KeyEscrow.BuergerKeyEscrow> BuergerKeyEscrows { get; set; } = null!;
    public DbSet<Prozess.Schritt> Schritte { get; set; } = null!;
    public DbSet<Prozess.ZustaendigkeitRolle> ZustaendigkeitRollen { get; set; } = null!;
    public DbSet<Prozess.Verbindung> Verbindungen { get; set; } = null!;
    public DbSet<Prozess.FormularSchritt> FormularSchritte { get; set; } = null!;
    public DbSet<Prozess.BezahlenSchritt> BezahlenSchritte { get; set; } = null!;
    public DbSet<Prozess.EndeSchritt> EndeSchritte { get; set; } = null!;
    public DbSet<Prozess.NachrichtSchritt> NachrichtSchritte { get; set; } = null!;
    public DbSet<Prozess.ProgrammatischerSchritt> ProgrammatischeSchritte { get; set; } = null!;

    public DbSet<Prozess.WarteAufBezahlungAbgeschlossenSchritt> WarteAufBezahlungAbgeschlossenSchritte { get; set; } =
        null!;

    public DbSet<Prozess.FormularFeld> FormularFelder { get; set; } = null!;
    public DbSet<Prozess.StringFormularFeld> StringFormularFelder { get; set; } = null!;
    public DbSet<Prozess.UploadFormularFeld> UploadFormularFelder { get; set; } = null!;
    public DbSet<Prozess.LocationFormularFeld> LocationFormularFelder { get; set; } = null!;
    public DbSet<Prozess.CheckboxListFormularFeld> CheckboxListFormularFelder { get; set; } = null!;
    public DbSet<Prozess.DateFormularFeld> DateFormularFelder { get; set; } = null!;
    public DbSet<Prozess.TimeFormularFeld> TimeFormularFelder { get; set; } = null!;
    public DbSet<Prozess.AnzeigeTextBlockFeld> ReadOnlyTextBlockFormularFeld { get; set; } = null!;
    public DbSet<Prozess.SignatureFormularFeld> SignatureFormularFelder { get; set; } = null!;
    public DbSet<PmPayment.PaymentRequest> PaymentRequests { get; set; } = null!;
    public DbSet<GovManagerRestExportSchritt> GovManagerRestExportSchritte { get; set; } = null!;
    public DbSet<WarteAufGovManagerSchritt> WarteAufGovManagerSchritte { get; set; } = null!;
    public DbSet<GovManagerRequest> GovManagerRequests { get; set; } = null!;
    public DbSet<EmailForwarderExportSchritt> EmailForwarderExportSchritte { get; set; } = null!;
    public DbSet<EmailOutboxItem> EmailOutboxItems { get; set; } = null!;
    public DbSet<EmailAttachment> EmailAttachments { get; set; } = null!;
    public DbSet<Dienstleister> Dienstleister { get; set; } = null!;
    public DbSet<Prozess.Kategorie> Kategorien { get; set; } = null!;
    public DbSet<Prozess.KategorieAusblendung> KategorieAusblendungen { get; set; } = null!;
    public DbSet<Ehrenamtsbank.EhrenamtsbankKategorie> EhrenamtsbankKategorien { get; set; } = null!;
    public DbSet<Ehrenamtsbank.EhrenamtsbankEintrag> EhrenamtsbankEintraege { get; set; } = null!;
    public DbSet<Aufbewahrung.AufbewahrungsEinstellungen> AufbewahrungsEinstellungen { get; set; } = null!;
    public DbSet<Aufbewahrung.AntragLoeschProtokoll> AntragLoeschProtokolle { get; set; } = null!;
    public DbSet<Ehrenamtsbank.EhrenamtsbankAnfrage> EhrenamtsbankAnfragen { get; set; } = null!;
    public DbSet<Ehrenamtsbank.EhrenamtsbankTransaktion> EhrenamtsbankTransaktionen { get; set; } = null!;
    public DbSet<ObjectStorage.ObjectDeletionOutboxItem> ObjectDeletionOutboxItems { get; set; } = null!;
    public DbSet<Lage.Lage> Lagen { get; set; } = null!;
    public DbSet<Lage.Gebiet> Gebiete { get; set; } = null!;
    public DbSet<Lage.LageGebiet> LageGebiete { get; set; } = null!;
    public DbSet<Lage.GebietEinsatzleitung> GebietEinsatzleitungen { get; set; } = null!;

    public DbSet<DataProtectionKey> DataProtectionKeys { get; set; } = null!;

    /// <summary>Konfiguriert das Modell anhand der aktuellen Assembly.</summary>
    /// <param name="modelBuilder">Der ModelBuilder zur Konfiguration.</param>
    protected override void OnModelCreating(ModelBuilder modelBuilder) {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly(),
        type => type.Name != nameof(BuergerEntityTypeConfiguration));

        modelBuilder.ApplyConfiguration(new BuergerEntityTypeConfiguration(_dataProtectionProvider));
    }

    /// <summary>Konfiguriert Konventionen für bestimmte Eigenschaftstypen.</summary>
    /// <param name="configurationBuilder">Der Builder zur Konfiguration von Modelleigenschaften.</param>
    protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder) {
        configurationBuilder
            .Properties<EncryptedValue>()
            .HaveConversion<EncryptedValueConverter>();
        configurationBuilder
            .Properties<StringExpression>()
            .HaveConversion<StringExpressionValueConverter>();
        configurationBuilder
            .Properties<IntExpression>()
            .HaveConversion<IntExpressionValueConverter>();
        configurationBuilder
            .Properties<BoolExpression>()
            .HaveConversion<BoolExpressionValueConverter>();
    }
}
