import {Color} from '@jgleman/color-box';
import {
  createContext,
  type CSSProperties,
  type ReactNode,
  useContext,
  useEffect,
} from 'react';
import {type Kommune, useKommuneQuery} from './kommune.generated.ts';

/**
 * Eigenschaften für den Kommune-Provider, entweder mit einer Kommune-ID oder einer Kommune.
 */
type KommuneProviderProps = {
  children?: ReactNode;
} & (
  | {
      kommuneId: string;
    }
  | {kommune: Kommune}
);

/**
 * Werttyp für den Kommune-Kontext mit ID, Name und optionaler Logo-URL.
 */
type KommuneContextValue = {
  id: string;
  name: string;
  logoUrl?: string;
  mangelIconUrl?: string;
  ideenIconUrl?: string;
};

/**
 * React-Kontext zur Bereitstellung von Kommunedaten.
 */
const KommuneContext = createContext<KommuneContextValue | null>(null);

/**
 * Provider-Komponente, die Kommunedaten lädt und im Kontext bereitstellt.
 * @param children Eingebettete React-Komponenten
 * @param props Entweder eine kommuneId oder eine Kommune
 * @returns JSX-Element mit Kommune-Kontext oder null, falls keine Kommune vorhanden
 */
export const KommuneProvider = ({children, ...props}: KommuneProviderProps) => {
  const kommuneId = 'kommuneId' in props ? props.kommuneId : null;
  const [{data}] = useKommuneQuery({
    variables: {kommuneId: kommuneId ?? ''},
    pause: !kommuneId,
  });
  const kommune = 'kommune' in props ? props.kommune : data?.kommune;
  const {name, design} = kommune ?? {};
  const {colors, logo, mangelIcon, ideenIcon} = design ?? {};

  useEffect(() => {
    const oldStyle: Record<string, CSSProperties[keyof CSSProperties]> = {};
    const newStyle = createCssVariables(colors ?? {});

    for (const key in newStyle) {
      const newValue = newStyle[key as keyof CSSProperties];
      oldStyle[key] = newValue;
      document.documentElement.style.setProperty(
        key,
        newValue?.toString() ?? null,
      );
    }
  }, [colors]);

  if (!kommune || !name) return null;
  return (
    <KommuneContext.Provider
      value={{
        id: kommune.id,
        logoUrl: logo?.url ?? undefined,
        mangelIconUrl: mangelIcon?.url ?? undefined,
        ideenIconUrl: ideenIcon?.url ?? undefined,
        name,
      }}
    >
      {children}
    </KommuneContext.Provider>
  );
};

/**
 * Hook zum Zugriff auf den aktuellen Kommune-Kontext.
 * @throws Fehler, wenn der Kontext nicht vorhanden ist
 * @returns Die aktuellen Kommunedaten aus dem Kontext
 */
export const useKommune = () => {
  const kommune = useContext(KommuneContext);
  if (!kommune) {
    throw new Error('Missing KommuneContext');
  }
  return kommune;
};

/**
 * Erzeugt CSS-Variablen aus einem Farb-Record, filtert private Schlüssel aus.
 * @param colors Farbwerte als Schlüssel-Wert-Paare
 * @returns CSSProperties mit CSS-Variablen für Farben im RGB-Format
 */
const createCssVariables = (colors: Record<string, string | null>) =>
  Object.fromEntries(
    Object.entries(colors ?? {})
      .filter(([k]) => !k.startsWith('_'))
      .map(([key, value]) => [
        `--color-${kebabCase(key)}`,
        toNakedRgb(value ?? '#000'),
      ]),
  ) as CSSProperties;

/**
 * Wandelt einen camelCase-String in kebab-case um.
 * @param s Eingabestring im camelCase
 * @returns String im kebab-case
 */
const kebabCase = (s: string) =>
  s.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();

/**
 * Wandelt einen Hex-Farbcode in eine nackte RGB-Darstellung um.
 * @param hex Hexadezimaler Farbcode
 * @returns String mit den RGB-Werten getrennt durch Leerzeichen
 */
const toNakedRgb = (hex: string) => {
  const {
    rgb: {r, g, b},
  } = new Color(hex);
  return `${r} ${g} ${b}`;
};
