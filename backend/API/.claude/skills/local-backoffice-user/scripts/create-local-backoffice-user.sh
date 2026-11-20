#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Create or update a local Bereich A BackofficeUser with Superadmin role.

Usage:
  create-local-backoffice-user.sh --email EMAIL [options]

Options:
  --email EMAIL                 Required. Login email for the user.
  --password PASSWORD           Plain browser password. Default: 123456
  --first-name NAME             Default: Local
  --last-name NAME              Default: Superadmin
  --art ART                     Nutzer | Admin | Superadmin | Dienstleister. Default: Superadmin
  --global-permission NAME      GlobaleFunktionsberechtigung (e.g. Prozessverwaltung). Repeatable.
                                Giving any replaces the user's global permissions.
  --unit "NAME=PERM,PERM"       Per-Untereinheit permissions (FunktionsberechtigungInOrganisationseinheit).
                                NAME is the Untereinheit name; PERM list may be '*' for all assignable.
                                Repeatable. Giving any replaces the user's unit permissions.
  --dienstleister NAME          Link the user to this Dienstleister (created if missing).
  --group NAME                  Add the user to this MitarbeiterGruppe (must exist). Repeatable.
                                Giving any skips --copy-groups-from.
  --connection-string STRING    Default: local docker Postgres connection.
  --copy-groups-from EMAIL      Copy group memberships from this user. Default: superadmin-hapy@example.com
  --no-copy-groups              Do not copy group memberships.
  -h, --help                    Show this help.

Environment:
  KOMMUNALAPP_DOMAIN_CONNECTION Overrides the default connection string.
USAGE
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
API_DIR="$(cd -- "$SCRIPT_DIR/../../../.." && pwd -P)"

EMAIL=""
PASSWORD="123456"
FIRST_NAME="Local"
LAST_NAME="Superadmin"
ART="Superadmin"
DIENSTLEISTER=""
GLOBAL_PERMISSIONS=()
UNITS=()
GROUPS_=()
CONNECTION_STRING="${KOMMUNALAPP_DOMAIN_CONNECTION:-Server=127.0.0.1;Port=5432;Database=db;UserId=admin;Password=password;Enlist=false}"
COPY_GROUPS_FROM="superadmin-hapy@example.com"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --email)
      EMAIL="${2:-}"
      shift 2
      ;;
    --password)
      PASSWORD="${2:-}"
      shift 2
      ;;
    --first-name)
      FIRST_NAME="${2:-}"
      shift 2
      ;;
    --last-name)
      LAST_NAME="${2:-}"
      shift 2
      ;;
    --art)
      ART="${2:-}"
      shift 2
      ;;
    --global-permission)
      GLOBAL_PERMISSIONS+=("${2:-}")
      shift 2
      ;;
    --unit)
      UNITS+=("${2:-}")
      shift 2
      ;;
    --dienstleister)
      DIENSTLEISTER="${2:-}"
      shift 2
      ;;
    --group)
      GROUPS_+=("${2:-}")
      shift 2
      ;;
    --connection-string)
      CONNECTION_STRING="${2:-}"
      shift 2
      ;;
    --copy-groups-from)
      COPY_GROUPS_FROM="${2:-}"
      shift 2
      ;;
    --no-copy-groups)
      COPY_GROUPS_FROM=""
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$EMAIL" ]]; then
  echo "--email is required" >&2
  usage >&2
  exit 2
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cat > "$TMP_DIR/LocalBackofficeUser.csproj" <<EOF
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <TreatWarningsAsErrors>false</TreatWarningsAsErrors>
  </PropertyGroup>
  <ItemGroup>
    <ProjectReference Include="$API_DIR/API.csproj" />
    <PackageReference Include="System.Text.Json" Version="9.0.0" />
  </ItemGroup>
</Project>
EOF

cat > "$TMP_DIR/Program.cs" <<'EOF'
using System.Security.Cryptography;
using System.Text;
using API.Features;
using API.Features.Auth;
using API.Features.Dienstleistungen;
using API.Features.Funktionsberechtigungen;
using API.Features.Untereinheit;
using API.Infrastructure;
using API.Seeders;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

var options = ParseArgs(args);
var email = options.Email.Trim().ToLowerInvariant();
if (string.IsNullOrWhiteSpace(email) || !email.Contains('@')) {
    throw new ArgumentException("A valid --email is required.");
}

var dbOptions = new DbContextOptionsBuilder<DomainContext>()
    .UseNpgsql(options.ConnectionString, npgsql => npgsql.UseNodaTime())
    .Options;

var dataProtectionProvider = DataProtectionProvider.Create(
    new DirectoryInfo(Path.Combine(Path.GetTempPath(), "kommunalapp-local-backoffice-user-dp")));

await using var db = new DomainContext(dbOptions, dataProtectionProvider);
var kommuneSeed = KommuneSeeder.LandkreisHaPy;

var kommune = await db.Kommunen.AsTracking().FirstOrDefaultAsync(k => k.Id == kommuneSeed.Id);
if (kommune is null) {
    kommune = new API.Features.Kommune.Kommune {
        Id = kommuneSeed.Id,
        Name = kommuneSeed.Name,
        PublicKey = Convert.ToBase64String(kommuneSeed.UnsafeRsa.ExportSubjectPublicKeyInfo()),
        PrivateKey = Crypto.Encrypt(kommuneSeed.UnsafeRsa.ExportPkcs8PrivateKey(), kommuneSeed.KeyEncryptionKey),
    };
    db.Kommunen.Add(kommune);
}

var user = await db.BackofficeUser
    .AsTracking()
    .Include(u => u.Gruppen)
    .FirstOrDefaultAsync(u => u.EMail == email);

var created = false;
if (user is null) {
    user = new BackofficeUser {
        Id = Guid.NewGuid(),
        EMail = email,
        Vorname = options.FirstName,
        Nachname = options.LastName,
        KommuneId = kommuneSeed.Id,
        Gruppen = [],
        UntereinheitPermissions = [],
    };
    db.BackofficeUser.Add(user);
    created = true;
} else if (user.KommuneId != kommuneSeed.Id) {
    throw new InvalidOperationException(
        $"User {email} already exists for KommuneId {user.KommuneId}, not local HaPy {kommuneSeed.Id}.");
}

user.Vorname = options.FirstName;
user.Nachname = options.LastName;
user.Art = options.Art;
user.IsDeleted = false;
user.IsSyncedToBereichB = false;
user.InvitationCode = null;
user.InvitationValidUntil = null;
user.PendingConfirmation = null;
user.PasswordResetCode = null;
user.PasswordResetValidUntil = null;

SetLocalPasswordAndCrypto(user, options.Password, kommuneSeed.KeyEncryptionKey);

if (options.GlobalPermissions.Count > 0) {
    user.Funktionsberechtigungen = options.GlobalPermissions
        .Select(name => ParseEnum<GlobaleFunktionsberechtigung>(name))
        .Distinct()
        .ToList();
}

if (options.Units.Count > 0) {
    var unitNames = options.Units.Select(u => u.Name).ToList();
    var units = await db.Untereinheit
        .Where(u => u.KommuneId == kommuneSeed.Id && unitNames.Contains(u.Name))
        .ToListAsync();

    var existingPermissions = await db.UntereinheitPermissions
        .AsTracking()
        .Where(p => p.BackofficeUserId == user.Id)
        .ToListAsync();
    db.UntereinheitPermissions.RemoveRange(existingPermissions);
    user.UntereinheitPermissions = [];

    foreach (var (unitName, permissionNames) in options.Units) {
        var unit = units.FirstOrDefault(u => u.Name == unitName)
            ?? throw new InvalidOperationException($"Untereinheit '{unitName}' not found in local HaPy kommune.");
        var permissions = permissionNames.Contains("*")
            ? Enum.GetValues<FunktionsberechtigungInOrganisationseinheit>().ToList()
            : permissionNames.Select(name => ParseEnum<FunktionsberechtigungInOrganisationseinheit>(name)).Distinct().ToList();
        user.UntereinheitPermissions.Add(new UntereinheitPermissions {
            UntereinheitId = unit.Id,
            BackofficeUserId = user.Id,
            Funktionsberechtigungen = permissions,
        });
    }
}

if (!string.IsNullOrWhiteSpace(options.Dienstleister)) {
    var dienstleister = await db.Dienstleister.AsTracking()
        .FirstOrDefaultAsync(d => d.MandantId == kommuneSeed.Id && d.Name == options.Dienstleister);
    if (dienstleister is null) {
        dienstleister = new Dienstleister {
            Id = Guid.NewGuid(),
            MandantId = kommuneSeed.Id,
            Name = options.Dienstleister,
            EMailAdressen = [email],
        };
        db.Dienstleister.Add(dienstleister);
    }
    user.Dienstleister = dienstleister;
    user.DienstleisterId = dienstleister.Id;
}

if (options.Groups.Count > 0) {
    var groups = await db.MitarbeiterGruppen
        .AsTracking()
        .Where(g => g.KommuneId == kommuneSeed.Id && !g.IsDeleted && options.Groups.Contains(g.Name))
        .ToListAsync();
    var missing = options.Groups.Except(groups.Select(g => g.Name)).ToList();
    if (missing.Count > 0) {
        throw new InvalidOperationException($"MitarbeiterGruppe not found: {string.Join(", ", missing)}");
    }
    user.Gruppen = groups;
} else if (!string.IsNullOrWhiteSpace(options.CopyGroupsFrom)) {
    var sourceEmail = options.CopyGroupsFrom.Trim().ToLowerInvariant();
    var source = await db.BackofficeUser
        .AsTracking()
        .Include(u => u.Gruppen)
        .FirstOrDefaultAsync(u => u.EMail == sourceEmail);

    if (source is null) {
        Console.Error.WriteLine($"Warning: group copy source {sourceEmail} was not found; leaving groups unchanged.");
    } else {
        user.Gruppen = source.Gruppen.Where(g => g.KommuneId == kommuneSeed.Id).ToList();
    }
}

await db.SaveChangesAsync();

Console.WriteLine(created ? "Created local Bereich A backoffice user." : "Updated local Bereich A backoffice user.");
Console.WriteLine($"Id:       {user.Id}");
Console.WriteLine($"Email:    {user.EMail}");
Console.WriteLine($"Password: {options.Password}");
Console.WriteLine($"Art:      {user.Art}");
Console.WriteLine($"Global:   {string.Join(", ", user.Funktionsberechtigungen)}");
foreach (var permission in user.UntereinheitPermissions) {
    Console.WriteLine($"Unit:     {permission.UntereinheitId} -> {string.Join(", ", permission.Funktionsberechtigungen)}");
}
Console.WriteLine($"Groups:   {string.Join(", ", user.Gruppen.Select(g => g.Name))}");
if (user.DienstleisterId is not null) Console.WriteLine($"Dienstleister: {options.Dienstleister} ({user.DienstleisterId})");

static TEnum ParseEnum<TEnum>(string name) where TEnum : struct, Enum =>
    Enum.TryParse<TEnum>(name, ignoreCase: true, out var value)
        ? value
        : throw new ArgumentException($"Unknown {typeof(TEnum).Name} '{name}'. Valid: {string.Join(", ", Enum.GetNames<TEnum>())}");

static void SetLocalPasswordAndCrypto(BackofficeUser user, string plainPassword, byte[] organisationKey) {
    using var personalRsa = RSA.Create(4096);
    var passwordHasher = new PasswordHasher<User>();

    user.PublicKey = Convert.ToBase64String(personalRsa.ExportSubjectPublicKeyInfo());

    var serverLoginPassword = Convert.ToBase64String(
        Crypto.DeriveKey(plainPassword, Encoding.UTF8.GetBytes(user.EMail), 512));
    user.Password = passwordHasher.HashPassword(user, serverLoginPassword);

    var personalPrivateKeySalt = RandomNumberGenerator.GetBytes(64);
    user.PersonalPrivateKeySalt = Convert.ToBase64String(personalPrivateKeySalt);

    var privateKeyEncryptionKey = Crypto.DeriveKey(plainPassword, personalPrivateKeySalt, 256);
    user.PersonalPrivateKey = Crypto.Encrypt(personalRsa.ExportPkcs8PrivateKey(), privateKeyEncryptionKey);

    user.OrganisationPrivateKey = Convert.ToBase64String(
        personalRsa.Encrypt(organisationKey, RSAEncryptionPadding.OaepSHA512));
}

static Options ParseArgs(string[] args) {
    var result = new Options();
    for (var i = 0; i < args.Length; i++) {
        var arg = args[i];
        string Next() {
            if (i + 1 >= args.Length) throw new ArgumentException($"{arg} requires a value.");
            return args[++i];
        }

        switch (arg) {
            case "--email":
                result.Email = Next();
                break;
            case "--password":
                result.Password = Next();
                break;
            case "--first-name":
                result.FirstName = Next();
                break;
            case "--last-name":
                result.LastName = Next();
                break;
            case "--art":
                result.Art = Enum.Parse<BackofficeNutzerArt>(Next(), ignoreCase: true);
                break;
            case "--global-permission":
                result.GlobalPermissions.Add(Next());
                break;
            case "--unit": {
                var raw = Next();
                var separator = raw.IndexOf('=');
                if (separator <= 0) throw new ArgumentException("--unit expects NAME=PERM,PERM");
                var permissions = raw[(separator + 1)..].Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries).ToList();
                result.Units.Add((raw[..separator].Trim(), permissions));
                break;
            }
            case "--dienstleister":
                result.Dienstleister = Next();
                break;
            case "--group":
                result.Groups.Add(Next());
                break;
            case "--connection-string":
                result.ConnectionString = Next();
                break;
            case "--copy-groups-from":
                result.CopyGroupsFrom = Next();
                break;
            case "--no-copy-groups":
                result.CopyGroupsFrom = "";
                break;
            default:
                throw new ArgumentException($"Unknown helper argument: {arg}");
        }
    }

    return result;
}

sealed class Options {
    public string Email { get; set; } = "";
    public string Password { get; set; } = "123456";
    public string FirstName { get; set; } = "Local";
    public string LastName { get; set; } = "Superadmin";
    public List<string> GlobalPermissions { get; } = [];
    public List<(string Name, List<string> Permissions)> Units { get; } = [];
    public string Dienstleister { get; set; } = "";
    public List<string> Groups { get; } = [];
    public BackofficeNutzerArt Art { get; set; } = BackofficeNutzerArt.Superadmin;
    public string ConnectionString { get; set; } = "Server=127.0.0.1;Port=5432;Database=db;UserId=admin;Password=password;Enlist=false";
    public string CopyGroupsFrom { get; set; } = "superadmin-hapy@example.com";
}
EOF

RUN_ARGS=(
  --email "$EMAIL"
  --password "$PASSWORD"
  --first-name "$FIRST_NAME"
  --last-name "$LAST_NAME"
  --art "$ART"
  --connection-string "$CONNECTION_STRING"
)

for value in ${GLOBAL_PERMISSIONS[@]+"${GLOBAL_PERMISSIONS[@]}"}; do RUN_ARGS+=(--global-permission "$value"); done
for value in ${UNITS[@]+"${UNITS[@]}"}; do RUN_ARGS+=(--unit "$value"); done
for value in ${GROUPS_[@]+"${GROUPS_[@]}"}; do RUN_ARGS+=(--group "$value"); done
[[ -n "$DIENSTLEISTER" ]] && RUN_ARGS+=(--dienstleister "$DIENSTLEISTER")

if [[ -n "$COPY_GROUPS_FROM" ]]; then
  RUN_ARGS+=(--copy-groups-from "$COPY_GROUPS_FROM")
else
  RUN_ARGS+=(--no-copy-groups)
fi

dotnet run --project "$TMP_DIR/LocalBackofficeUser.csproj" -- "${RUN_ARGS[@]}"
