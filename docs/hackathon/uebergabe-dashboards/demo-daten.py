"""Builds the DEICH dashboard demo on the local stack through the real GraphQL API.

Usage (backend on localhost:5000, KRL seed applied, an ACTIVE Lage in OE Hameln-Pyrmont):
    python3 docs/hackathon/uebergabe-dashboards/demo-daten.py backend/API/Seeders/LageHelfer/Data/krl/seed.json

The seed's process needs the categories "Sturm" and "Überschwemmung". Safe to rerun: existing Einheiten and live
Gebiete are kept, reports are only created for numbers that do not exist yet. Waiting times and report numbers are
set directly in the local database so the demo matches the mock.
"""
import base64
import hashlib
import json
import os
import random
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request

API = "http://localhost:5000/graphql"
SEED = sys.argv[1]
KOMMUNE_ID = "84a06067-dc9e-46d0-b60a-8258cf7c1ce7"
random.seed(7)


def sql(query):
    out = subprocess.run(["docker", "exec", "hameln-postgres", "psql", "-U", "admin", "-d", "db", "-At", "-c", query],
                         capture_output=True, text=True, check=True).stdout
    return [line.split("|") for line in out.strip().splitlines() if line]


def gql(query, variables=None, token=None):
    req = urllib.request.Request(API, data=json.dumps({"query": query, "variables": variables or {}}).encode(),
                                 headers={"Content-Type": "application/json", "GraphQL-preflight": "1"})
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    for versuch in range(8):
        try:
            with urllib.request.urlopen(req) as res:
                body = json.load(res)
            break
        except urllib.error.HTTPError:
            if versuch == 7:
                raise
            time.sleep(6)
    if body.get("errors"):
        raise RuntimeError(json.dumps(body["errors"])[:500])
    return body["data"]


def mutate(token, field, input_type, payload, selection="ausfuehrung { id }"):
    data = gql(f"mutation($input: {input_type}!) {{ {field}(input: $input) {{ {selection} errors {{ __typename ... on Error {{ message }} }} }} }}",
               {"input": payload}, token)[field]
    if data.get("errors"):
        print(f"  ! {field}: {data['errors'][0].get('message')}")
    return data


seed = json.load(open(SEED))
password = seed["demo"]["passwort"]
EMAIL = "admin-krl@example.com"
server_password = base64.b64encode(hashlib.pbkdf2_hmac("sha512", password.encode(), EMAIL.encode(), 100_000, 64)).decode()
token = gql("mutation($i: LoginInput!) { login(input: $i) { result token } }",
            {"i": {"email": EMAIL, "password": server_password}})["login"]["token"]
assert token, "Login fehlgeschlagen"

lage = gql("{ lagen(status: ACTIVE) { id untereinheitId title gebiete { gebietId status } } }", token=token)["lagen"][0]
gebiete = gql("{ gebiete { id name untereinheitId geometry einsatzleitungen { id name } } }", token=token)["gebiete"]
gebiete = [g for g in gebiete if g["untereinheitId"] == lage["untereinheitId"] and g["einsatzleitungen"]]
by_name = {g["name"]: g for g in gebiete}
print("Lage", lage["title"], "Gebiete mit Einsatzleitung:", ", ".join(sorted(by_name)))

im_lage = {g["gebietId"]: g["status"] for g in lage["gebiete"]}
fehlend = [g["id"] for g in gebiete if g["id"] not in im_lage or im_lage[g["id"]] in ("ENDED", "DONE")]
if fehlend:
    mutate(token, "addGebieteToLage", "AddGebieteToLageInput", {"lageId": lage["id"], "gebietIds": fehlend}, "lage { id }")
for pass_ in gql("query($id: UUID!) { lage(id: $id) { gebiete { gebietId status } } }", {"id": lage["id"]}, token)["lage"]["gebiete"]:
    if pass_["gebietId"] not in {g["id"] for g in gebiete}:
        continue
    steps = {"INACTIVE": ["CALLED_OUT", "READY", "LIVE"], "CALLED_OUT": ["READY", "LIVE"], "READY": ["LIVE"]}.get(pass_["status"], [])
    for status in steps:
        mutate(token, "setLageGebietStatus", "SetLageGebietStatusInput",
               {"lageId": lage["id"], "gebietId": pass_["gebietId"], "status": status}, "lage { id }")
mutate(token, "setLageMeldeweg", "SetLageMeldewegInput", {"lageId": lage["id"], "offen": True}, "lage { id }")

el_of = {name: g["einsatzleitungen"][0]["id"] for name, g in by_name.items()}
einheiten = {e["name"] for e in gql("{ einheiten { name } }", token=token)["einheiten"]}
for gemeinde, name in [("Hameln", "DLK 23/12 Hameln"), ("Aerzen", "LF 10 Aerzen"), ("Emmerthal", "HLF 10 Emmerthal"),
                       ("Bad Pyrmont", "TLF 4000 Bad Pyrmont"), ("Hessisch Oldendorf", "TLF 3000 Hessisch Oldendorf"),
                       ("Coppenbrügge", "MTW Coppenbrügge"), ("Bad Münder", "RW Bad Münder")]:
    if name not in einheiten and gemeinde in el_of:
        mutate(token, "createEinheit", "CreateEinheitInput", {"name": name, "mitarbeiterGruppeId": el_of[gemeinde]},
               "einheit { id }")
        print("  Einheit angelegt:", name)
einheit_id = {e["name"]: e["id"] for e in gql("{ einheiten { id name } }", token=token)["einheiten"]}

prozess = sql('select v."Id", v."StartId", vb."Id" from "ProzessVersionen" v '
              'join "Verbindungen" vb on vb."VonId"=v."StartId" '
              'join "ProzessProzessTag" pt on pt."ProzesseId"=v."ProzessId" '
              'join "ProzessTags" t on t."Id"=pt."TagsId" and t."Tag"=$$LageHelfer$$ '
              'join "UserFacingProzesse" p on p."Id"=v."ProzessId" '
              f'where p."KommuneId"=$${KOMMUNE_ID}$$ and v."PublishedAt" is not null '
              'order by v."PublishedAt" desc limit 1')[0]
public_key = sql(f'select "PublicKey" from "Kommunen" where "Id"=$${KOMMUNE_ID}$$')[0][0]


def shared_key():
    with tempfile.TemporaryDirectory() as d:
        pem = os.path.join(d, "k.pem")
        der = base64.b64decode(public_key)
        with open(pem, "w") as f:
            f.write("-----BEGIN PUBLIC KEY-----\n" + base64.encodebytes(der).decode() + "-----END PUBLIC KEY-----\n")
        out = subprocess.run(["openssl", "pkeyutl", "-encrypt", "-pubin", "-inkey", pem, "-pkeyopt", "rsa_padding_mode:oaep",
                              "-pkeyopt", "rsa_oaep_md:sha512", "-pkeyopt", "rsa_mgf1_md:sha512"],
                             input=os.urandom(32), capture_output=True, check=True).stdout
    return base64.b64encode(out).decode()


def punkt_in(gemeinde):
    geometry = json.loads(by_name[gemeinde]["geometry"])
    ring = geometry["coordinates"][0] if geometry["type"] == "Polygon" else max(
        (p[0] for p in geometry["coordinates"]), key=len)
    xs, ys = [p[0] for p in ring], [p[1] for p in ring]

    def inside(x, y):
        hit = False
        for (x1, y1), (x2, y2) in zip(ring, ring[1:] + ring[:1]):
            if (y1 > y) != (y2 > y) and x < (x2 - x1) * (y - y1) / (y2 - y1) + x1:
                hit = not hit
        return hit
    cx, cy = sum(xs) / len(xs), sum(ys) / len(ys)
    for _ in range(2000):
        x = cx + (random.random() - 0.5) * (max(xs) - min(xs)) * 0.5
        y = cy + (random.random() - 0.5) * (max(ys) - min(ys)) * 0.5
        if inside(x, y):
            return x, y
    raise RuntimeError(f"kein Punkt in {gemeinde}")


# number, category, description, Gemeinde, Ortsteil/Straße, +1, waiting minutes, state
MELDUNGEN = [
    (1042, "Sturm", "Baum liegt quer über der Fahrbahn", "Hameln", "Wohngebiet Nord", 7, 130, "eingegangen"),
    (1053, "Überschwemmung", "Straße überflutet, Gully läuft über", "Hameln", "Innenstadt", 5, 40, "eingegangen"),
    (1051, "Sturm", "Dachziegel lose, fallen auf Gehweg", "Bad Münder", "Ortskern", 3, 55, "eingegangen"),
    (1058, "Sturm", "Großer Ast auf Spielplatz", "Coppenbrügge", "Am Spielplatz", 1, 15, "eingegangen"),
    (1047, "Überschwemmung", "Keller vollgelaufen, ca. 30 cm Wasser", "Hessisch Oldendorf", "Lange Straße", 0, 85, "eingegangen"),
    (1060, "Sturm", "Baum blockiert Zufahrt zum Wohngebiet", "Hameln", "Klein Berkel", 2, 25, "eingegangen"),
    (1049, "Überschwemmung", "Unterführung überflutet", "Emmerthal", "Bahnhofstraße", 4, 65, "eingegangen"),
    (1044, "Sturm", "Bauzaun umgeweht", "Bad Pyrmont", "Brunnenstraße", 2, 90, "zugewiesen:TLF 4000 Bad Pyrmont"),
    (1031, "Sturm", "Baum auf geparktem Pkw", "Hameln", "Deisterallee", 2, 150, "laeuft:HLF 20 Hameln"),
    (1040, "Überschwemmung", "Keller unter Wasser", "Bad Münder", "Süntelstraße", 0, 120, "laeuft:RW Bad Münder"),
    (1046, "Überschwemmung", "Wasser im Keller des Gemeindehauses", "Aerzen", "Ortsmitte", 0, 140, "klaerung:KEINE_EINHEIT_FREI:Alle Pumpen im Einsatz"),
    (1039, "Sturm", "Mehrere Bäume auf Waldweg", "Coppenbrügge", "Ith-Waldweg", 1, 35, "klaerung:AUSRUESTUNG_FEHLT:Radlader nötig"),
    (1063, "Sturm", "Baum aufs Haus gefallen, Nachbarin noch drin", "Bad Pyrmont", "Hauptallee", 0, 6, "eingegangen"),
    (1021, "Sturm", "Ast auf Radweg", "Hameln", "Weserpromenade", 1, 200, "erledigt:HLF 20 Hameln"),
    (1024, "Überschwemmung", "Gully verstopft, Wasser steht", "Emmerthal", "Kirchohsen", 0, 190, "erledigt:HLF 10 Emmerthal"),
    (1027, "Sturm", "Verkehrsschild umgeknickt", "Aerzen", "Reherweg", 0, 170, "erledigt:LF 10 Aerzen"),
]

vorhanden = {int(n) for n, in sql('select "Meldungsnummer" from "Ausfuehrungen" where "Meldungsnummer" is not null')}
create = """mutation($input: AusfuehrungCreateAnonymInput!) { ausfuehrungCreateAnonym(input: $input) {
  anonymeAusfuehrungResult { correlationId meldungsnummer } errors { __typename } } }"""
neu = []
for nummer, kat, text, gemeinde, strasse, plus, minuten, state in MELDUNGEN:
    if nummer in vorhanden:
        continue
    lng, lat = punkt_in(gemeinde)
    slots = [("adresse", {"addressString": f"{gemeinde}, {strasse}", "coordinates": [lng, lat]}),
             ("kategorie", kat), ("beschreibung", text)]
    result = gql(create, {"input": {
        "prozessVersionId": prozess[0], "sharedKeyEncryptedForKommune": shared_key(),
        "lage": {"lageId": lage["id"], "gebietId": by_name[gemeinde]["id"]},
        "bearbeitungen": [{"schrittId": prozess[1], "nextVerbindungId": prozess[2],
                           "slotValues": [{"name": n, "value": {"plainValue": v}} for n, v in slots]}]}})["ausfuehrungCreateAnonym"]
    if result.get("errors"):
        print("  ! create", nummer, result["errors"])
        continue
    temp = result["anonymeAusfuehrungResult"]["meldungsnummer"]
    sql(f'update "Ausfuehrungen" set "Meldungsnummer"={nummer}, "CreatedAt"=now() - interval $${minuten} minutes$$ '
        f'where "Meldungsnummer"={temp}')
    neu.append((nummer, plus, state))
    print("  Meldung", nummer, text)
sql("select setval($$\"Meldungsnummern\"$$, 1100)")

print("Warte auf die Zuordnung zur Einsatzleitung …")
for _ in range(60):
    offen = sql('select count(*) from "Ausfuehrungen" where "LageGebietId" is not null and "Meldungsnummer" between 1020 and 1099 '
                'and ("IstZustaendigkeit_MitarbeiterGruppeId" is null)')
    if offen and offen[0][0] == "0":
        break
    time.sleep(5)
else:
    print("  ! Zuständigkeitsschritt lief nicht in 5 Minuten")

for nummer, _, _, _, _, plus, _, state in MELDUNGEN:
    zeile = sql(f'select "Id", "PublicId", "Status", "EinheitId", "KlaerungSeit" from "Ausfuehrungen" '
                f'where "Meldungsnummer"={nummer}')
    if not zeile or zeile[0][2] == "2":
        continue
    aid, public_id, _, einheit, klaerung = zeile[0]
    schon = int(sql(f'select count(*) from "MeldungBestaetigungen" where "AusfuehrungId"=$${aid}$$')[0][0])
    for _ in range(plus - schon):
        gql("mutation($i: MeldungBestaetigenInput!) { meldungBestaetigen(input: $i) { errors { __typename } } }",
            {"i": {"publicId": public_id, "fotos": None}})
    art, _, rest = state.partition(":")
    if art in ("zugewiesen", "laeuft", "erledigt") and not einheit:
        mutate(token, "meldungEinheitZuweisen", "MeldungEinheitZuweisenInput",
               {"ausfuehrungId": aid, "einheitId": einheit_id[rest]})
    if art == "laeuft" and not einheit:
        mutate(token, "meldungFortsetzen", "MeldungFortsetzenInput", {"ausfuehrungId": aid, "aktion": "HILFE_EINLEITEN"})
    if art == "erledigt":
        mutate(token, "meldungFortsetzen", "MeldungFortsetzenInput", {"ausfuehrungId": aid, "aktion": "EINSATZ_ABSCHLIESSEN"})
    print("  Stand gesetzt:", nummer, state)
    if art == "klaerung" and not klaerung:
        grund, _, kommentar = rest.partition(":")
        mutate(token, "meldungAnLeitstelleAbgeben", "MeldungAnLeitstelleAbgebenInput",
               {"ausfuehrungId": aid, "grund": grund, "kommentar": kommentar})
        sql(f'update "Ausfuehrungen" set "KlaerungSeit"="CreatedAt" + interval $$5 minutes$$ where "Id"=$${aid}$$')
print("Fertig.")
