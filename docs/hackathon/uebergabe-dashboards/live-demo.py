"""Plays a storm scenario for the live demo: a new Meldung arrives every few seconds, through the real GraphQL API.

Prerequisites: backend running, KRL seed applied, an ACTIVE Lage whose Gebiete are LIVE (demo-daten.py sets that up).

    python3 docs/hackathon/uebergabe-dashboards/live-demo.py                       # 50 Meldungen, then it stops
    python3 docs/hackathon/uebergabe-dashboards/live-demo.py --interval 3          # faster
    python3 docs/hackathon/uebergabe-dashboards/live-demo.py --api http://localhost:5001/graphql
    python3 docs/hackathon/uebergabe-dashboards/live-demo.py --dry-run             # print the storyline only

The storyline has 28 entries; after that random non-emergency Meldungen follow until the count is reached.
Meldungen get the next free number and the current time. Nothing is deleted, so a repeated run adds more Meldungen.
"""
import argparse
import base64
import hashlib
import json
import os
import pathlib
import random
import subprocess
import sys
import tempfile
import time
import urllib.request
from datetime import datetime

ROOT = pathlib.Path(__file__).resolve().parents[3]

# (Gemeinde, street, category, description, emergency). Ordered so the load builds up; "emergency" only marks the
# entries meant to trip the backend's emergency detection (MeldungEinschaetzung.NotfallMuster) for the log output.
STORYLINE = [
    ("Hameln", "Deisterallee", "Unwetter", "Ast auf Radweg", False),
    ("Aerzen", "Reherweg", "Unwetter", "Verkehrsschild umgeknickt", False),
    ("Bad Pyrmont", "Brunnenstraße", "Unwetter", "Bauzaun umgeweht", False),
    ("Coppenbrügge", "Am Spielplatz", "Unwetter", "Großer Ast auf Spielplatz", False),
    ("Hameln", "Klein Berkel", "Unwetter", "Baum blockiert Zufahrt zum Wohngebiet", False),
    ("Bad Münder", "Ortskern", "Hagelsturm", "Dachziegel lose, fallen auf Gehweg", False),
    ("Emmerthal", "Kirchohsen", "Unwetter", "Gully verstopft, Wasser steht", False),
    ("Hessisch Oldendorf", "Lange Straße", "Unwetter", "Keller vollgelaufen, ca. 30 cm Wasser", False),
    ("Hameln", "Wohngebiet Nord", "Unwetter", "Baum liegt quer über der Fahrbahn", False),
    ("Bad Pyrmont", "Hauptallee", "Unwetter", "Baum aufs Haus gefallen, Nachbarin noch drin", True),
    ("Emmerthal", "Bahnhofstraße", "Unwetter", "Unterführung überflutet", False),
    ("Coppenbrügge", "Ith-Waldweg", "Unwetter", "Mehrere Bäume auf Waldweg", False),
    ("Hameln", "Innenstadt", "Unwetter", "Straße überflutet, Gully läuft über", False),
    ("Aerzen", "Ortsmitte", "Unwetter", "Wasser im Keller des Gemeindehauses", False),
    ("Bad Münder", "Süntelstraße", "Unwetter", "Keller unter Wasser", False),
    ("Hessisch Oldendorf", "Hauptstraße", "Unwetter", "Baum auf geparktem Pkw", False),
    ("Hameln", "Weserpromenade", "Unwetter", "Stromleitung hängt auf die Straße, Funken sprühen", True),
    ("Emmerthal", "Hajen", "Unwetter", "Dach teilweise abgedeckt", False),
    ("Bad Pyrmont", "Altenauplatz", "Unwetter", "Umgestürzter Baum blockiert die Straße", False),
    ("Coppenbrügge", "Marienau", "Unwetter", "Straße durch Schlamm unpassierbar", False),
    ("Aerzen", "Dehmkerbrock", "Unwetter", "Autofahrer im Wasser eingeklemmt, Fahrzeug steht quer", True),
    ("Hameln", "Afferde", "Unwetter", "Gartenhaus umgekippt, Trümmer auf der Fahrbahn", False),
    ("Bad Münder", "Nammen", "Unwetter", "Bach tritt über die Ufer, Straße überflutet", False),
    ("Hessisch Oldendorf", "Fischbeck", "Unwetter", "Kellerfenster eingedrückt, Wasser steigt", False),
    ("Hameln", "Tündern", "Unwetter", "Dachziegel fallen auf Gehweg", False),
    ("Emmerthal", "Grohnde", "Unwetter", "Baum droht auf Wohnhaus zu fallen", False),
    ("Bad Pyrmont", "Holzhausen", "Unwetter", "Ast hängt über der Fahrbahn", False),
    ("Hameln", "Hastenbeck", "Unwetter", "Keller vollgelaufen, Heizung aus", False),
]

args_parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
args_parser.add_argument("seed", nargs="?", default=str(ROOT / "backend/API/Seeders/LageHelfer/Data/krl/seed.json"))
args_parser.add_argument("--api", default=os.environ.get("GRAPHQL_URL", "http://localhost:5000/graphql"))
args_parser.add_argument("--interval", type=float, default=5, help="mean seconds between Meldungen (default 5)")
args_parser.add_argument("--count", type=int, default=50, help="stop after this many Meldungen (default 50)")
args_parser.add_argument("--confirm-chance", type=float, default=0.35,
                         help="chance per Meldung that a neighbour confirms an earlier one (+1), default 0.35")
args_parser.add_argument("--seed-random", type=int, default=7)
args_parser.add_argument("--dry-run", action="store_true")
args = args_parser.parse_args()
random.seed(args.seed_random)


def pause():
    time.sleep(max(0.2, random.gauss(args.interval, args.interval * 0.25)))


def log(message):
    print(f"{datetime.now():%H:%M:%S}  {message}", flush=True)


def next_meldung(index):
    if index < len(STORYLINE):
        return STORYLINE[index]
    return random.choice([m for m in STORYLINE if not m[4]])


total = args.count
if args.dry_run:
    for i in range(total):
        gemeinde, street, category, text, emergency = next_meldung(i)
        print(f"{i + 1:>3}  {gemeinde}, {street}: {text}{'  [NOTFALL]' if emergency else ''}")
    sys.exit(0)

seed = json.load(open(args.seed))
KOMMUNE_ID = seed["kommune"]["id"]
EMAIL = "admin-krl@example.com"


def sql(query):
    out = subprocess.run(["docker", "exec", "hameln-postgres", "psql", "-U", "admin", "-d", "db", "-At", "-c", query],
                         capture_output=True, text=True, check=True).stdout
    return [line.split("|") for line in out.strip().splitlines() if line]


def gql(query, variables=None, token=None):
    request = urllib.request.Request(args.api, data=json.dumps({"query": query, "variables": variables or {}}).encode(),
                                     headers={"Content-Type": "application/json", "GraphQL-preflight": "1"})
    if token:
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request, timeout=30) as response:
        body = json.load(response)
    if body.get("errors"):
        raise RuntimeError(json.dumps(body["errors"])[:400])
    return body["data"]


server_password = base64.b64encode(hashlib.pbkdf2_hmac(
    "sha512", seed["demo"]["passwort"].encode(), EMAIL.encode(), 100_000, 64)).decode()
token = gql("mutation($i: LoginInput!) { login(input: $i) { token } }",
            {"i": {"email": EMAIL, "password": server_password}})["login"]["token"]
assert token, "Login fehlgeschlagen"

lage = gql("{ lagen(status: ACTIVE) { id untereinheitId title gebiete { gebietId status } } }", token=token)["lagen"][0]
live_ids = {g["gebietId"] for g in lage["gebiete"] if g["status"] == "LIVE"}
gebiete = {g["name"]: g for g in gql("{ gebiete { id name geometry } }", token=token)["gebiete"] if g["id"] in live_ids}
log(f"Lage '{lage['title']}', LIVE-Gebiete: {', '.join(sorted(gebiete))}")
missing = {m[0] for m in STORYLINE} - set(gebiete)
if missing:
    print(f"Warnung: nicht LIVE oder unbekannt, diese Meldungen werden übersprungen: {', '.join(sorted(missing))}", file=sys.stderr)

process_version, start_step, first_connection = sql(
    'select v."Id", v."StartId", vb."Id" from "ProzessVersionen" v '
    'join "Verbindungen" vb on vb."VonId"=v."StartId" '
    'join "UserFacingProzesse" p on p."Id"=v."ProzessId" '
    f'where p."KommuneId"=$${KOMMUNE_ID}$$ and v."PublishedAt" is not null '
    'order by v."PublishedAt" desc limit 1')[0]
public_key = sql(f'select "PublicKey" from "Kommunen" where "Id"=$${KOMMUNE_ID}$$')[0][0]


def shared_key():
    with tempfile.TemporaryDirectory() as directory:
        pem = os.path.join(directory, "key.pem")
        with open(pem, "w") as file:
            file.write("-----BEGIN PUBLIC KEY-----\n" + base64.encodebytes(base64.b64decode(public_key)).decode()
                       + "-----END PUBLIC KEY-----\n")
        encrypted = subprocess.run(
            ["openssl", "pkeyutl", "-encrypt", "-pubin", "-inkey", pem, "-pkeyopt", "rsa_padding_mode:oaep",
             "-pkeyopt", "rsa_oaep_md:sha512", "-pkeyopt", "rsa_mgf1_md:sha512"],
            input=os.urandom(32), capture_output=True, check=True).stdout
    return base64.b64encode(encrypted).decode()


def point_in(gemeinde):
    geometry = json.loads(gebiete[gemeinde]["geometry"])
    ring = geometry["coordinates"][0] if geometry["type"] == "Polygon" else max(
        (polygon[0] for polygon in geometry["coordinates"]), key=len)
    xs, ys = [p[0] for p in ring], [p[1] for p in ring]

    def inside(x, y):
        hit = False
        for (x1, y1), (x2, y2) in zip(ring, ring[1:] + ring[:1]):
            if (y1 > y) != (y2 > y) and x < (x2 - x1) * (y - y1) / (y2 - y1) + x1:
                hit = not hit
        return hit

    center_x, center_y = sum(xs) / len(xs), sum(ys) / len(ys)
    for _ in range(2000):
        x = center_x + (random.random() - 0.5) * (max(xs) - min(xs)) * 0.5
        y = center_y + (random.random() - 0.5) * (max(ys) - min(ys)) * 0.5
        if inside(x, y):
            return x, y
    raise RuntimeError(f"kein Punkt in {gemeinde}")


CREATE = """mutation($input: AusfuehrungCreateAnonymInput!) { ausfuehrungCreateAnonym(input: $input) {
  anonymeAusfuehrungResult { meldungsnummer } errors { __typename } } }"""
CONFIRM = "mutation($i: MeldungBestaetigenInput!) { meldungBestaetigen(input: $i) { errors { __typename } } }"


def create_meldung(gemeinde, street, category, text):
    lng, lat = point_in(gemeinde)
    slots = [("adresse", {"addressString": f"{gemeinde}, {street}", "coordinates": [lng, lat]}),
             ("kategorie", category), ("beschreibung", text)]
    result = gql(CREATE, {"input": {
        "prozessVersionId": process_version, "sharedKeyEncryptedForKommune": shared_key(),
        "lage": {"lageId": lage["id"], "gebietId": gebiete[gemeinde]["id"]},
        "bearbeitungen": [{"schrittId": start_step, "nextVerbindungId": first_connection,
                           "slotValues": [{"name": n, "value": {"plainValue": v}} for n, v in slots]}]}})["ausfuehrungCreateAnonym"]
    if result["errors"]:
        raise RuntimeError(result["errors"])
    return result["anonymeAusfuehrungResult"]["meldungsnummer"]


def confirm_meldung(number):
    public_id = sql(f'select "PublicId" from "Ausfuehrungen" where "Meldungsnummer"={number}')[0][0]
    gql(CONFIRM, {"i": {"publicId": public_id, "fotos": None}})


assert gebiete, "Keine LIVE-Gebiete in der aktiven Lage"
sent = []
attempts = 0
position = 0
try:
    while attempts < total:
        gemeinde, street, category, text, emergency = next_meldung(position)
        position += 1
        if gemeinde not in gebiete:
            continue
        attempts += 1
        try:
            number = create_meldung(gemeinde, street, category, text)
            sent.append(number)
            log(f"E-{number}  {gemeinde}, {street}: {text}{'  [NOTFALL]' if emergency else ''}")
            if len(sent) > 2 and random.random() < args.confirm_chance:
                confirmed = random.choice(sent[:-1])
                confirm_meldung(confirmed)
                log(f"E-{confirmed}  +1 Bestätigung")
        except Exception as error:
            log(f"Fehler bei '{text}': {error}")
        if attempts < total:
            pause()
except KeyboardInterrupt:
    pass
log(f"Ende: {len(sent)} Meldungen gesendet.")
