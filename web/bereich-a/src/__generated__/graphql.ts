export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends {[key: string]: unknown}> = {[K in keyof T]: T[K]};
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]?: Maybe<T[SubKey]>;
};
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]: Maybe<T[SubKey]>;
};
export type MakeEmpty<T extends {[key: string]: unknown}, K extends keyof T> = {
  [_ in K]?: never;
};
export type Incremental<T> =
  | T
  | {[P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never};

/** Warum die Einsatzleitung eine Meldung an die Leitstelle abgibt. */
export enum AbgabeGrund {
  AusruestungFehlt = 'AUSRUESTUNG_FEHLT',
  KeineEinheitFrei = 'KEINE_EINHEIT_FREI',
  KeinFallFuerFeuerwehr = 'KEIN_FALL_FUER_FEUERWEHR',
  NichtUnserGebiet = 'NICHT_UNSER_GEBIET',
  Sonstiges = 'SONSTIGES',
}

export enum ApplyPolicy {
  AfterResolver = 'AFTER_RESOLVER',
  BeforeResolver = 'BEFORE_RESOLVER',
  Validation = 'VALIDATION',
}

export enum Aufrufe_QrCode_Type {
  Contact = 'contact',
  Coordinates = 'coordinates',
  None = 'none',
  Url = 'url',
}

export enum Aufrufe_QrCode__Type_Input {
  Contact = 'contact',
  Coordinates = 'coordinates',
  None = 'none',
  Url = 'url',
}

export enum AusfuehrungStatus {
  Abgeschlossen = 'ABGESCHLOSSEN',
  BearbeitungDurchBuerger = 'BEARBEITUNG_DURCH_BUERGER',
  BearbeitungDurchKommune = 'BEARBEITUNG_DURCH_KOMMUNE',
}

export enum BackofficeNutzerArt {
  Admin = 'ADMIN',
  Dienstleister = 'DIENSTLEISTER',
  Nutzer = 'NUTZER',
  Superadmin = 'SUPERADMIN',
}

export enum BackofficeNutzerStatus {
  InvitationExpired = 'INVITATION_EXPIRED',
  Invited = 'INVITED',
  Registered = 'REGISTERED',
}

export enum EhrenamtsbankAnfrageStatus {
  Abgelehnt = 'ABGELEHNT',
  Akzeptiert = 'AKZEPTIERT',
  Erledigt = 'ERLEDIGT',
  Offen = 'OFFEN',
  Vereinbart = 'VEREINBART',
  Zurueckgezogen = 'ZURUECKGEZOGEN',
}

export enum EhrenamtsbankAnfrageTyp {
  EigeneAnfrage = 'EIGENE_ANFRAGE',
  EmpfangeneAnfrage = 'EMPFANGENE_ANFRAGE',
}

export enum EhrenamtsbankDringlichkeit {
  Hoch = 'HOCH',
  Mittel = 'MITTEL',
  Niedrig = 'NIEDRIG',
}

export enum EhrenamtsbankEintragStatus {
  Active = 'ACTIVE',
  Assigned = 'ASSIGNED',
  Closed = 'CLOSED',
  Completed = 'COMPLETED',
  Draft = 'DRAFT',
  Paused = 'PAUSED',
  PendingReview = 'PENDING_REVIEW',
}

export enum EhrenamtsbankEintragTyp {
  Angebot = 'ANGEBOT',
  Gesuch = 'GESUCH',
}

export enum EhrenamtsbankTransaktionCreatedBy {
  Admin = 'ADMIN',
  System = 'SYSTEM',
}

/** Rolle des Aufrufers in einer Buchung. */
export enum EhrenamtsbankTransaktionRolle {
  Giver = 'GIVER',
  Receiver = 'RECEIVER',
}

export enum EhrenamtsbankTransaktionStatus {
  Adjusted = 'ADJUSTED',
  Cancelled = 'CANCELLED',
  Confirmed = 'CONFIRMED',
}

/** Stand einer LageHelfer-Meldung, wie ihn Leitstelle und Einsatzleitung sehen. */
export enum EreignisStatus {
  /** Eingegangen, noch keiner Einheit zugewiesen. */
  Eingegangen = 'EINGEGANGEN',
  /** Einsatz abgeschlossen. */
  Erledigt = 'ERLEDIGT',
  /** Von der Leitstelle an eine externe Stelle (Bauhof, THW, ELS) übergeben und damit abgeschlossen. */
  ExternUebergeben = 'EXTERN_UEBERGEBEN',
  /** Hilfe eingeleitet (Bürger:innen sehen "Hilfe ist unterwegs"). */
  InBearbeitung = 'IN_BEARBEITUNG',
  /** Von der Einsatzleitung an die Leitstelle abgegeben. */
  InKlaerung = 'IN_KLAERUNG',
  /** Von der Leitstelle mit Begründung verworfen. */
  Verworfen = 'VERWORFEN',
  /** Einer Einheit zugewiesen, Hilfe noch nicht eingeleitet. */
  Zugewiesen = 'ZUGEWIESEN',
}

/** Stelle außerhalb der Einsatzleitungen, die eine Meldung übernimmt. */
export enum ExterneStelle {
  Bauhof = 'BAUHOF',
  /** Einsatzleitsystem der 112 (Übergabe als EIDO). */
  Els = 'ELS',
  Thw = 'THW',
}

export enum FallbackLocaleInputType {
  De = 'de',
  En = 'en',
  None = 'none',
}

export enum FunktionsberechtigungInOrganisationseinheit {
  Backoffice = 'BACKOFFICE',
  BackofficeAntraege = 'BACKOFFICE_ANTRAEGE',
  BackofficeDienstleisterverwaltung = 'BACKOFFICE_DIENSTLEISTERVERWALTUNG',
  BackofficeNutzendenverwaltung = 'BACKOFFICE_NUTZENDENVERWALTUNG',
  Inhaltspflege = 'INHALTSPFLEGE',
  InhaltspflegeAufrufe = 'INHALTSPFLEGE_AUFRUFE',
  InhaltspflegeGeoflaechen = 'INHALTSPFLEGE_GEOFLAECHEN',
  InhaltspflegeIntegrationen = 'INHALTSPFLEGE_INTEGRATIONEN',
  InhaltspflegeNewsArtikel = 'INHALTSPFLEGE_NEWS_ARTIKEL',
  InhaltspflegePois = 'INHALTSPFLEGE_POIS',
  InhaltspflegeSensoren = 'INHALTSPFLEGE_SENSOREN',
  InhaltspflegeVeranstaltungen = 'INHALTSPFLEGE_VERANSTALTUNGEN',
  InhaltspflegeWettermesspunkte = 'INHALTSPFLEGE_WETTERMESSPUNKTE',
  MaengelmelderZustaendigkeitsverwaltung = 'MAENGELMELDER_ZUSTAENDIGKEITSVERWALTUNG',
}

export enum GlobaleFunktionsberechtigung {
  AntragLoeschung = 'ANTRAG_LOESCHUNG',
  ArchivEinsicht = 'ARCHIV_EINSICHT',
  AufbewahrungVerwaltung = 'AUFBEWAHRUNG_VERWALTUNG',
  Ehrenamtsbank = 'EHRENAMTSBANK',
  LageHelfer = 'LAGE_HELFER',
  Prozessverwaltung = 'PROZESSVERWALTUNG',
}

export enum HistoryMode {
  LastDay = 'LAST_DAY',
  LastWeek = 'LAST_WEEK',
}

export enum Integration_Integrationtype {
  Ikiss = 'IKISS',
  IkissVeranstaltungen = 'IKISS_VERANSTALTUNGEN',
  Nolis = 'NOLIS',
  Rss = 'RSS',
}

export enum KommuneDesignFonts_Body {
  CenturyGothic = 'CenturyGothic',
  Mulish = 'Mulish',
  NotoSans = 'NotoSans',
  RobotoSlab = 'RobotoSlab',
}

export enum KommuneDesignFonts_Headings {
  CenturyGothic = 'CenturyGothic',
  Mulish = 'Mulish',
  NotoSans = 'NotoSans',
  RobotoSlab = 'RobotoSlab',
}

export enum LageGebietStatus {
  CalledOut = 'CALLED_OUT',
  Done = 'DONE',
  Ended = 'ENDED',
  Inactive = 'INACTIVE',
  Live = 'LIVE',
  Ready = 'READY',
}

export enum LageStatus {
  Active = 'ACTIVE',
  Closed = 'CLOSED',
  Created = 'CREATED',
}

export enum LocaleInputType {
  De = 'de',
  En = 'en',
}

export enum LoginResult {
  NeedsConfirmation = 'NEEDS_CONFIRMATION',
  Success = 'SUCCESS',
  WrongLogin = 'WRONG_LOGIN',
}

export enum LogoutAllDevicesResult {
  DeviceLoginKept = 'DEVICE_LOGIN_KEPT',
  LoggedOut = 'LOGGED_OUT',
}

/** Schritt, den die Einsatzleitung an einer Meldung im Prozess geht. */
export enum MeldungAktion {
  /** Einsatz abschließen; leitet vorher Hilfe ein, falls das noch nicht geschehen ist. */
  EinsatzAbschliessen = 'EINSATZ_ABSCHLIESSEN',
  /** Hilfe einleiten: Bürger:innen sehen "Hilfe ist unterwegs". */
  HilfeEinleiten = 'HILFE_EINLEITEN',
}

/** Klasse einer Meldung nach dem Eisenhower-Schema. */
export enum MeldungKlasse {
  /** Dringend und wichtig. */
  A = 'A',
  /** Wichtig, nicht dringend. */
  B = 'B',
  /** Dringend, nicht wichtig. */
  C = 'C',
  /** Weder dringend noch wichtig. */
  D = 'D',
}

/** Stand einer Meldung, wie ihn die meldende Person sieht. */
export enum MeldungStatus {
  /** Abgeschlossen, es folgen keine weiteren Änderungen. */
  Abgeschlossen = 'ABGESCHLOSSEN',
  /** Eingegangen, noch nicht von der Einsatzleitung übernommen. */
  Eingegangen = 'EINGEGANGEN',
  /** Die Einsatzleitung hat Hilfe eingeleitet. */
  HilfeUnterwegs = 'HILFE_UNTERWEGS',
  /** Von der Einsatzleitung übernommen, einer Einheit zugewiesen oder bereits bearbeitet. */
  InBearbeitung = 'IN_BEARBEITUNG',
}

export enum NewsArtikel__Status {
  Draft = 'draft',
  Published = 'published',
}

export enum NewsArtikel__Status_Input {
  Draft = 'draft',
  Published = 'published',
}

/** Ergebnis der Notfall-Prüfung durch die Leitstelle. */
export enum NotfallPruefung {
  /** An das Einsatzleitsystem übergeben; die Meldung ist damit für den Meldeweg abgeschlossen. */
  AnElsUebergeben = 'AN_ELS_UEBERGEBEN',
  KeinNotfall = 'KEIN_NOTFALL',
}

export enum PasswordConfirmationResult {
  CodeExpired = 'CODE_EXPIRED',
  InvalidCode = 'INVALID_CODE',
  Success = 'SUCCESS',
}

export enum PendingConfirmationReason {
  Invited = 'INVITED',
  PasswordReset = 'PASSWORD_RESET',
}

export enum Poi_AdditionalInformation_Kind {
  Email = 'email',
  Other = 'other',
  Phone = 'phone',
  Website = 'website',
}

export enum Poi_AdditionalInformation__Kind_Input {
  Email = 'email',
  Other = 'other',
  Phone = 'phone',
  Website = 'website',
}

export enum RegisterBackofficeUserResult {
  CodeExpired = 'CODE_EXPIRED',
  InvalidCode = 'INVALID_CODE',
  Success = 'SUCCESS',
}

export enum RequestSmsResult {
  BundIdLoginRequired = 'BUND_ID_LOGIN_REQUIRED',
  InvalidFormat = 'INVALID_FORMAT',
  InvalidPhone = 'INVALID_PHONE',
  SameAsCurrentPhoneNumber = 'SAME_AS_CURRENT_PHONE_NUMBER',
  SmsDeliveryFailed = 'SMS_DELIVERY_FAILED',
  Success = 'SUCCESS',
}

export enum SlotValueType {
  Boolean = 'BOOLEAN',
  Date = 'DATE',
  Location = 'LOCATION',
  ReadOnly = 'READ_ONLY',
  Signature = 'SIGNATURE',
  String = 'STRING',
  Time = 'TIME',
  Upload = 'UPLOAD',
}

export enum SortEnumType {
  Asc = 'ASC',
  Desc = 'DESC',
}

export enum StringValidationType {
  Default = 'DEFAULT',
  Iban = 'IBAN',
}

export enum ValidateCodeResult {
  CodeExpired = 'CODE_EXPIRED',
  CodeLocked = 'CODE_LOCKED',
  ExistingAccountRequiresBundIdReverification = 'EXISTING_ACCOUNT_REQUIRES_BUND_ID_REVERIFICATION',
  InvalidCode = 'INVALID_CODE',
  NoVerificationCodeRequested = 'NO_VERIFICATION_CODE_REQUESTED',
  Success = 'SUCCESS',
}

export enum WeiterleitungArt {
  Kopieren = 'KOPIEREN',
  Schliessen = 'SCHLIESSEN',
}

export enum WeiterleitungEmpfaenger {
  Extern = 'EXTERN',
  Intern = 'INTERN',
}

export enum ZustaendigkeitArt {
  Buerger = 'BUERGER',
  Dienstleister = 'DIENSTLEISTER',
  Dynamisch = 'DYNAMISCH',
  Organisationseinheit = 'ORGANISATIONSEINHEIT',
}
