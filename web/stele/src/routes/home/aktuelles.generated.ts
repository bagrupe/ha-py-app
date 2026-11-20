import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type Aufrufe_Aufrufende_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_BeschreibungText_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_Beschreibung_Operator = {
  contains?: unknown | null;
  equals?: unknown | null;
  like?: unknown | null;
  not_equals?: unknown | null;
};

export type Aufrufe_Bild__External_Operator = {
  equals?: boolean | null;
  exists?: boolean | null;
  not_equals?: boolean | null;
};

export type Aufrufe_Bild__Internal_Operator = {
  all?: Array<unknown | null> | null;
  equals?: unknown | null;
  exists?: boolean | null;
  in?: Array<unknown | null> | null;
  not_equals?: unknown | null;
  not_in?: Array<unknown | null> | null;
};

export type Aufrufe_Bild__Url_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_CreatedAt_Operator = {
  equals?: Date | null;
  exists?: boolean | null;
  greater_than?: Date | null;
  greater_than_equal?: Date | null;
  less_than?: Date | null;
  less_than_equal?: Date | null;
  like?: Date | null;
  not_equals?: Date | null;
};

export type Aufrufe_EndDatum_Operator = {
  equals?: Date | null;
  exists?: boolean | null;
  greater_than?: Date | null;
  greater_than_equal?: Date | null;
  less_than?: Date | null;
  less_than_equal?: Date | null;
  like?: Date | null;
  not_equals?: Date | null;
};

export type Aufrufe_FallbackBildUrl_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_Id_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_Kommune_Operator = {
  all?: Array<unknown | null> | null;
  equals?: unknown | null;
  in?: Array<unknown | null> | null;
  not_equals?: unknown | null;
  not_in?: Array<unknown | null> | null;
};

export type Aufrufe_QrCodeUrl_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_QrCode__Contact__Address_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_QrCode__Contact__Email_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_QrCode__Contact__Name_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_QrCode__Contact__Phone_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_QrCode__Coordinates_Operator = {
  equals?: Array<number | null> | null;
  exists?: boolean | null;
  greater_than?: Array<number | null> | null;
  greater_than_equal?: Array<number | null> | null;
  intersects?: GeoJsonObject | null;
  less_than?: Array<number | null> | null;
  less_than_equal?: Array<number | null> | null;
  near?: Array<number | null> | null;
  not_equals?: Array<number | null> | null;
  within?: GeoJsonObject | null;
};

export type Aufrufe_QrCode__Type_Operator = {
  all?: Array<Types.Aufrufe_QrCode__Type_Input | null> | null;
  equals?: Types.Aufrufe_QrCode__Type_Input | null;
  exists?: boolean | null;
  in?: Array<Types.Aufrufe_QrCode__Type_Input | null> | null;
  not_equals?: Types.Aufrufe_QrCode__Type_Input | null;
  not_in?: Array<Types.Aufrufe_QrCode__Type_Input | null> | null;
};

export type Aufrufe_QrCode__Url_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_StartDatum_Operator = {
  equals?: Date | null;
  exists?: boolean | null;
  greater_than?: Date | null;
  greater_than_equal?: Date | null;
  less_than?: Date | null;
  less_than_equal?: Date | null;
  like?: Date | null;
  not_equals?: Date | null;
};

export type Aufrufe_Teaser_Operator = {
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  like?: string | null;
  not_equals?: string | null;
};

export type Aufrufe_Titel_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type Aufrufe_Untereinheit_Operator = {
  all?: Array<unknown | null> | null;
  equals?: unknown | null;
  exists?: boolean | null;
  in?: Array<unknown | null> | null;
  not_equals?: unknown | null;
  not_in?: Array<unknown | null> | null;
};

export type Aufrufe_UpdatedAt_Operator = {
  equals?: Date | null;
  exists?: boolean | null;
  greater_than?: Date | null;
  greater_than_equal?: Date | null;
  less_than?: Date | null;
  less_than_equal?: Date | null;
  like?: Date | null;
  not_equals?: Date | null;
};

export type Aufrufe_Where = {
  AND?: Array<Aufrufe_Where_And | null> | null;
  OR?: Array<Aufrufe_Where_Or | null> | null;
  aufrufende?: Aufrufe_Aufrufende_Operator | null;
  beschreibung?: Aufrufe_Beschreibung_Operator | null;
  beschreibungText?: Aufrufe_BeschreibungText_Operator | null;
  bild__external?: Aufrufe_Bild__External_Operator | null;
  bild__internal?: Aufrufe_Bild__Internal_Operator | null;
  bild__url?: Aufrufe_Bild__Url_Operator | null;
  createdAt?: Aufrufe_CreatedAt_Operator | null;
  endDatum?: Aufrufe_EndDatum_Operator | null;
  fallbackBildUrl?: Aufrufe_FallbackBildUrl_Operator | null;
  id?: Aufrufe_Id_Operator | null;
  kommune?: Aufrufe_Kommune_Operator | null;
  qrCodeUrl?: Aufrufe_QrCodeUrl_Operator | null;
  qrCode__contact__address?: Aufrufe_QrCode__Contact__Address_Operator | null;
  qrCode__contact__email?: Aufrufe_QrCode__Contact__Email_Operator | null;
  qrCode__contact__name?: Aufrufe_QrCode__Contact__Name_Operator | null;
  qrCode__contact__phone?: Aufrufe_QrCode__Contact__Phone_Operator | null;
  qrCode__coordinates?: Aufrufe_QrCode__Coordinates_Operator | null;
  qrCode__type?: Aufrufe_QrCode__Type_Operator | null;
  qrCode__url?: Aufrufe_QrCode__Url_Operator | null;
  startDatum?: Aufrufe_StartDatum_Operator | null;
  teaser?: Aufrufe_Teaser_Operator | null;
  titel?: Aufrufe_Titel_Operator | null;
  untereinheit?: Aufrufe_Untereinheit_Operator | null;
  updatedAt?: Aufrufe_UpdatedAt_Operator | null;
};

export type Aufrufe_Where_And = {
  AND?: Array<Aufrufe_Where_And | null> | null;
  OR?: Array<Aufrufe_Where_Or | null> | null;
  aufrufende?: Aufrufe_Aufrufende_Operator | null;
  beschreibung?: Aufrufe_Beschreibung_Operator | null;
  beschreibungText?: Aufrufe_BeschreibungText_Operator | null;
  bild__external?: Aufrufe_Bild__External_Operator | null;
  bild__internal?: Aufrufe_Bild__Internal_Operator | null;
  bild__url?: Aufrufe_Bild__Url_Operator | null;
  createdAt?: Aufrufe_CreatedAt_Operator | null;
  endDatum?: Aufrufe_EndDatum_Operator | null;
  fallbackBildUrl?: Aufrufe_FallbackBildUrl_Operator | null;
  id?: Aufrufe_Id_Operator | null;
  kommune?: Aufrufe_Kommune_Operator | null;
  qrCodeUrl?: Aufrufe_QrCodeUrl_Operator | null;
  qrCode__contact__address?: Aufrufe_QrCode__Contact__Address_Operator | null;
  qrCode__contact__email?: Aufrufe_QrCode__Contact__Email_Operator | null;
  qrCode__contact__name?: Aufrufe_QrCode__Contact__Name_Operator | null;
  qrCode__contact__phone?: Aufrufe_QrCode__Contact__Phone_Operator | null;
  qrCode__coordinates?: Aufrufe_QrCode__Coordinates_Operator | null;
  qrCode__type?: Aufrufe_QrCode__Type_Operator | null;
  qrCode__url?: Aufrufe_QrCode__Url_Operator | null;
  startDatum?: Aufrufe_StartDatum_Operator | null;
  teaser?: Aufrufe_Teaser_Operator | null;
  titel?: Aufrufe_Titel_Operator | null;
  untereinheit?: Aufrufe_Untereinheit_Operator | null;
  updatedAt?: Aufrufe_UpdatedAt_Operator | null;
};

export type Aufrufe_Where_Or = {
  AND?: Array<Aufrufe_Where_And | null> | null;
  OR?: Array<Aufrufe_Where_Or | null> | null;
  aufrufende?: Aufrufe_Aufrufende_Operator | null;
  beschreibung?: Aufrufe_Beschreibung_Operator | null;
  beschreibungText?: Aufrufe_BeschreibungText_Operator | null;
  bild__external?: Aufrufe_Bild__External_Operator | null;
  bild__internal?: Aufrufe_Bild__Internal_Operator | null;
  bild__url?: Aufrufe_Bild__Url_Operator | null;
  createdAt?: Aufrufe_CreatedAt_Operator | null;
  endDatum?: Aufrufe_EndDatum_Operator | null;
  fallbackBildUrl?: Aufrufe_FallbackBildUrl_Operator | null;
  id?: Aufrufe_Id_Operator | null;
  kommune?: Aufrufe_Kommune_Operator | null;
  qrCodeUrl?: Aufrufe_QrCodeUrl_Operator | null;
  qrCode__contact__address?: Aufrufe_QrCode__Contact__Address_Operator | null;
  qrCode__contact__email?: Aufrufe_QrCode__Contact__Email_Operator | null;
  qrCode__contact__name?: Aufrufe_QrCode__Contact__Name_Operator | null;
  qrCode__contact__phone?: Aufrufe_QrCode__Contact__Phone_Operator | null;
  qrCode__coordinates?: Aufrufe_QrCode__Coordinates_Operator | null;
  qrCode__type?: Aufrufe_QrCode__Type_Operator | null;
  qrCode__url?: Aufrufe_QrCode__Url_Operator | null;
  startDatum?: Aufrufe_StartDatum_Operator | null;
  teaser?: Aufrufe_Teaser_Operator | null;
  titel?: Aufrufe_Titel_Operator | null;
  untereinheit?: Aufrufe_Untereinheit_Operator | null;
  updatedAt?: Aufrufe_UpdatedAt_Operator | null;
};

export type GeoJsonObject = {
  coordinates?: unknown | null;
  type?: string | null;
};

export type NewsArtikel__Status_Operator = {
  all?: Array<Types.NewsArtikel__Status_Input | null> | null;
  equals?: Types.NewsArtikel__Status_Input | null;
  exists?: boolean | null;
  in?: Array<Types.NewsArtikel__Status_Input | null> | null;
  not_equals?: Types.NewsArtikel__Status_Input | null;
  not_in?: Array<Types.NewsArtikel__Status_Input | null> | null;
};

export type NewsArtikel_BodyPlaintext_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type NewsArtikel_CreatedAt_Operator = {
  equals?: Date | null;
  exists?: boolean | null;
  greater_than?: Date | null;
  greater_than_equal?: Date | null;
  less_than?: Date | null;
  less_than_equal?: Date | null;
  like?: Date | null;
  not_equals?: Date | null;
};

export type NewsArtikel_Datum_Operator = {
  equals?: Date | null;
  exists?: boolean | null;
  greater_than?: Date | null;
  greater_than_equal?: Date | null;
  less_than?: Date | null;
  less_than_equal?: Date | null;
  like?: Date | null;
  not_equals?: Date | null;
};

export type NewsArtikel_Id_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type NewsArtikel_ImportId_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type NewsArtikel_Integration_Operator = {
  all?: Array<unknown | null> | null;
  equals?: unknown | null;
  exists?: boolean | null;
  in?: Array<unknown | null> | null;
  not_equals?: unknown | null;
  not_in?: Array<unknown | null> | null;
};

export type NewsArtikel_Kommune_Operator = {
  all?: Array<unknown | null> | null;
  equals?: unknown | null;
  in?: Array<unknown | null> | null;
  not_equals?: unknown | null;
  not_in?: Array<unknown | null> | null;
};

export type NewsArtikel_Notified_Operator = {
  equals?: boolean | null;
  exists?: boolean | null;
  not_equals?: boolean | null;
};

export type NewsArtikel_Ordinal_Operator = {
  equals?: number | null;
  exists?: boolean | null;
  greater_than?: number | null;
  greater_than_equal?: number | null;
  less_than?: number | null;
  less_than_equal?: number | null;
  not_equals?: number | null;
};

export type NewsArtikel_OriginalUrl_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type NewsArtikel_Teaser_Operator = {
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  like?: string | null;
  not_equals?: string | null;
};

export type NewsArtikel_Titel_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type NewsArtikel_Titelbilder__Bild_Operator = {
  all?: Array<unknown | null> | null;
  equals?: unknown | null;
  exists?: boolean | null;
  in?: Array<unknown | null> | null;
  not_equals?: unknown | null;
  not_in?: Array<unknown | null> | null;
};

export type NewsArtikel_Titelbilder__Bildunterschrift_Operator = {
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  like?: string | null;
  not_equals?: string | null;
};

export type NewsArtikel_Titelbilder__Id_Operator = {
  all?: Array<string | null> | null;
  contains?: string | null;
  equals?: string | null;
  exists?: boolean | null;
  in?: Array<string | null> | null;
  like?: string | null;
  not_equals?: string | null;
  not_in?: Array<string | null> | null;
};

export type NewsArtikel_Untereinheit_Operator = {
  all?: Array<unknown | null> | null;
  equals?: unknown | null;
  exists?: boolean | null;
  in?: Array<unknown | null> | null;
  not_equals?: unknown | null;
  not_in?: Array<unknown | null> | null;
};

export type NewsArtikel_UpdatedAt_Operator = {
  equals?: Date | null;
  exists?: boolean | null;
  greater_than?: Date | null;
  greater_than_equal?: Date | null;
  less_than?: Date | null;
  less_than_equal?: Date | null;
  like?: Date | null;
  not_equals?: Date | null;
};

export type NewsArtikel_Visible_Operator = {
  equals?: boolean | null;
  exists?: boolean | null;
  not_equals?: boolean | null;
};

export type NewsArtikel_Where = {
  AND?: Array<NewsArtikel_Where_And | null> | null;
  OR?: Array<NewsArtikel_Where_Or | null> | null;
  _status?: NewsArtikel__Status_Operator | null;
  bodyPlaintext?: NewsArtikel_BodyPlaintext_Operator | null;
  createdAt?: NewsArtikel_CreatedAt_Operator | null;
  datum?: NewsArtikel_Datum_Operator | null;
  id?: NewsArtikel_Id_Operator | null;
  importId?: NewsArtikel_ImportId_Operator | null;
  integration?: NewsArtikel_Integration_Operator | null;
  kommune?: NewsArtikel_Kommune_Operator | null;
  notified?: NewsArtikel_Notified_Operator | null;
  ordinal?: NewsArtikel_Ordinal_Operator | null;
  originalUrl?: NewsArtikel_OriginalUrl_Operator | null;
  teaser?: NewsArtikel_Teaser_Operator | null;
  titel?: NewsArtikel_Titel_Operator | null;
  titelbilder__bild?: NewsArtikel_Titelbilder__Bild_Operator | null;
  titelbilder__bildunterschrift?: NewsArtikel_Titelbilder__Bildunterschrift_Operator | null;
  titelbilder__id?: NewsArtikel_Titelbilder__Id_Operator | null;
  untereinheit?: NewsArtikel_Untereinheit_Operator | null;
  updatedAt?: NewsArtikel_UpdatedAt_Operator | null;
  visible?: NewsArtikel_Visible_Operator | null;
};

export type NewsArtikel_Where_And = {
  AND?: Array<NewsArtikel_Where_And | null> | null;
  OR?: Array<NewsArtikel_Where_Or | null> | null;
  _status?: NewsArtikel__Status_Operator | null;
  bodyPlaintext?: NewsArtikel_BodyPlaintext_Operator | null;
  createdAt?: NewsArtikel_CreatedAt_Operator | null;
  datum?: NewsArtikel_Datum_Operator | null;
  id?: NewsArtikel_Id_Operator | null;
  importId?: NewsArtikel_ImportId_Operator | null;
  integration?: NewsArtikel_Integration_Operator | null;
  kommune?: NewsArtikel_Kommune_Operator | null;
  notified?: NewsArtikel_Notified_Operator | null;
  ordinal?: NewsArtikel_Ordinal_Operator | null;
  originalUrl?: NewsArtikel_OriginalUrl_Operator | null;
  teaser?: NewsArtikel_Teaser_Operator | null;
  titel?: NewsArtikel_Titel_Operator | null;
  titelbilder__bild?: NewsArtikel_Titelbilder__Bild_Operator | null;
  titelbilder__bildunterschrift?: NewsArtikel_Titelbilder__Bildunterschrift_Operator | null;
  titelbilder__id?: NewsArtikel_Titelbilder__Id_Operator | null;
  untereinheit?: NewsArtikel_Untereinheit_Operator | null;
  updatedAt?: NewsArtikel_UpdatedAt_Operator | null;
  visible?: NewsArtikel_Visible_Operator | null;
};

export type NewsArtikel_Where_Or = {
  AND?: Array<NewsArtikel_Where_And | null> | null;
  OR?: Array<NewsArtikel_Where_Or | null> | null;
  _status?: NewsArtikel__Status_Operator | null;
  bodyPlaintext?: NewsArtikel_BodyPlaintext_Operator | null;
  createdAt?: NewsArtikel_CreatedAt_Operator | null;
  datum?: NewsArtikel_Datum_Operator | null;
  id?: NewsArtikel_Id_Operator | null;
  importId?: NewsArtikel_ImportId_Operator | null;
  integration?: NewsArtikel_Integration_Operator | null;
  kommune?: NewsArtikel_Kommune_Operator | null;
  notified?: NewsArtikel_Notified_Operator | null;
  ordinal?: NewsArtikel_Ordinal_Operator | null;
  originalUrl?: NewsArtikel_OriginalUrl_Operator | null;
  teaser?: NewsArtikel_Teaser_Operator | null;
  titel?: NewsArtikel_Titel_Operator | null;
  titelbilder__bild?: NewsArtikel_Titelbilder__Bild_Operator | null;
  titelbilder__bildunterschrift?: NewsArtikel_Titelbilder__Bildunterschrift_Operator | null;
  titelbilder__id?: NewsArtikel_Titelbilder__Id_Operator | null;
  untereinheit?: NewsArtikel_Untereinheit_Operator | null;
  updatedAt?: NewsArtikel_UpdatedAt_Operator | null;
  visible?: NewsArtikel_Visible_Operator | null;
};

export type SteleAktuellesQueryVariables = Types.Exact<{
  aufrufeWhere: Aufrufe_Where;
  topThemaWhere: NewsArtikel_Where;
  newsWhere: NewsArtikel_Where;
  newsLimit?: Types.Maybe<number>;
}>;

export type SteleAktuellesQuery = {
  __typename?: 'Query';
  aufrufeList?: {
    __typename?: 'Aufrufes';
    docs: Array<{__typename?: 'Aufrufe'} & SteleAufrufInfoFragment>;
  } | null;
  topThemaNewsArtikelList?: {
    __typename?: 'NewsArtikels';
    docs: Array<{__typename?: 'NewsArtikel'} & SteleNewsArtikelInfoFragment>;
  } | null;
  newsArtikelList?: {
    __typename?: 'NewsArtikels';
    docs: Array<{__typename?: 'NewsArtikel'} & SteleNewsArtikelInfoFragment>;
  } | null;
};

export type SteleAufrufInfoFragment = {
  __typename?: 'Aufrufe';
  id: string;
  titel: string;
  teaser?: string | null;
  aufrufende: string;
  startDatum?: Date | null;
  beschreibungText?: string | null;
  fallbackBildUrl?: string | null;
  qrCodeUrl?: string | null;
  qrCode?: {
    __typename?: 'Aufrufe_QrCode';
    type?: Types.Aufrufe_QrCode_Type | null;
  } | null;
  bild?: {
    __typename?: 'Aufrufe_Bild';
    external?: boolean | null;
    url?: string | null;
    internal?: {
      __typename?: 'Aufrufemedien';
      id: string;
      url?: string | null;
      sizes?: {
        __typename?: 'Aufrufemedien_Sizes';
        thumbnail?: {
          __typename?: 'Aufrufemedien_Sizes_Thumbnail';
          url?: string | null;
        } | null;
      } | null;
    } | null;
  } | null;
  untereinheit?: {
    __typename?: 'BereichBUntereinheit';
    id: string;
    name: string;
  } | null;
  kommune?: {
    __typename?: 'BereichBKommune';
    id: string;
    name: string;
    design?: {
      __typename?: 'KommuneDesign';
      fallbackImage?: {
        __typename?: 'Medien';
        url?: string | null;
        sizes?: {
          __typename?: 'Medien_Sizes';
          thumbnail?: {
            __typename?: 'Medien_Sizes_Thumbnail';
            url?: string | null;
          } | null;
        } | null;
      } | null;
    } | null;
  } | null;
};

export type SteleNewsArtikelInfoFragment = {
  __typename?: 'NewsArtikel';
  id: string;
  titel?: string | null;
  teaser?: string | null;
  datum?: Date | null;
  ordinal?: number | null;
  bodyPlaintext?: string | null;
  untereinheit?: {
    __typename?: 'BereichBUntereinheit';
    id: string;
    name: string;
  } | null;
  kommune?: {
    __typename?: 'BereichBKommune';
    id: string;
    name: string;
    design?: {
      __typename?: 'KommuneDesign';
      fallbackImage?: {
        __typename?: 'Medien';
        url?: string | null;
        sizes?: {
          __typename?: 'Medien_Sizes';
          thumbnail?: {
            __typename?: 'Medien_Sizes_Thumbnail';
            url?: string | null;
          } | null;
        } | null;
      } | null;
    } | null;
  } | null;
  titelbilder?: Array<{
    __typename?: 'NewsArtikel_Titelbilder';
    id?: string | null;
    bild?: {
      __typename?: 'Veranstaltungsmedien';
      id: string;
      url?: string | null;
      sizes?: {
        __typename?: 'Veranstaltungsmedien_Sizes';
        thumbnail?: {
          __typename?: 'Veranstaltungsmedien_Sizes_Thumbnail';
          url?: string | null;
        } | null;
      } | null;
    } | null;
  }> | null;
};

export const SteleAufrufInfoFragmentDoc = gql`
  fragment SteleAufrufInfo on Aufrufe {
    id
    titel
    teaser
    aufrufende
    startDatum
    beschreibungText
    fallbackBildUrl
    qrCodeUrl
    qrCode {
      type
    }
    bild {
      external
      url
      internal {
        id
        url
        sizes {
          thumbnail {
            url
          }
        }
      }
    }
    untereinheit {
      id
      name
    }
    kommune {
      id
      name
      design {
        fallbackImage {
          url
          sizes {
            thumbnail {
              url
            }
          }
        }
      }
    }
  }
`;
export const SteleNewsArtikelInfoFragmentDoc = gql`
  fragment SteleNewsArtikelInfo on NewsArtikel {
    id
    titel
    teaser
    datum
    ordinal
    untereinheit {
      id
      name
    }
    kommune {
      id
      name
      design {
        fallbackImage {
          url
          sizes {
            thumbnail {
              url
            }
          }
        }
      }
    }
    titelbilder {
      id
      bild {
        id
        url
        sizes {
          thumbnail {
            url
          }
        }
      }
    }
    bodyPlaintext
  }
`;
export const SteleAktuellesDocument = gql`
  query SteleAktuelles(
    $aufrufeWhere: Aufrufe_where!
    $topThemaWhere: NewsArtikel_where!
    $newsWhere: NewsArtikel_where!
    $newsLimit: Int
  ) {
    aufrufeList(where: $aufrufeWhere, sort: "-startDatum") {
      docs {
        ...SteleAufrufInfo
      }
    }
    topThemaNewsArtikelList: newsArtikelList(
      where: $topThemaWhere
      sort: "-datum"
      limit: 1
    ) {
      docs {
        ...SteleNewsArtikelInfo
      }
    }
    newsArtikelList(where: $newsWhere, sort: "-datum", limit: $newsLimit) {
      docs {
        ...SteleNewsArtikelInfo
      }
    }
  }
  ${SteleAufrufInfoFragmentDoc}
  ${SteleNewsArtikelInfoFragmentDoc}
`;

export function useSteleAktuellesQuery(
  options: Omit<Urql.UseQueryArgs<SteleAktuellesQueryVariables>, 'query'>,
) {
  return Urql.useQuery<SteleAktuellesQuery, SteleAktuellesQueryVariables>({
    query: SteleAktuellesDocument,
    ...options,
  });
}
