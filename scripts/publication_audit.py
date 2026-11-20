"""Scan versioned content for high-confidence publication blockers without printing secrets."""

import argparse
import json
import pathlib
import re
import subprocess


def patterns():
    """Return secret signatures, including non-PEM private RSA material."""
    return {
        "private-key": re.compile(rb"-----BEGIN (?:RSA |EC |OPENSSH |DSA |ENCRYPTED )?PRIVATE KEY-----"),
        "private-rsa-xml": re.compile(rb"<RSAKeyValue>[\s\S]*?<D>[A-Za-z0-9+/=]+</D>"),
        "google-api-key": re.compile(rb"AIza[0-9A-Za-z_-]{35}"),
        "access-token": re.compile(rb"(?:gh[pousr]_[A-Za-z0-9]{30,}|glpat-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9-]{20,})"),
        "mapbox-token": re.compile(rb"[ps]k\.eyJ[A-Za-z0-9_.-]{30,}"),
        "jwt": re.compile(rb"eyJ[A-Za-z0-9_-]{15,}\.eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{20,}"),
        "service-account": re.compile(rb'"type"\s*:\s*"service_account"'),
    }


def scan(path, content, signatures):
    """Yield only locations and categories, never matching values."""
    if path.endswith(".md"):
        documented_password = re.compile(
            rb"(?i)(?:password|passwort)(?: ist f\xc3\xbcr jeden Nutzer| for every user is)?"
            rb"(?:\s*[:=]\s*|\s+)[`\"']?"
            rb"(?=[^\s`\"']{12,})(?=[^\s`\"']*(?-i:[A-Z]))(?=[^\s`\"']*[0-9])"
            rb"[^\s`\"']+"
        )
        for match in documented_password.finditer(content):
            yield {"path": path, "line": content[:match.start()].count(b"\n") + 1,
                   "category": "documented-password-review"}
    if path.endswith("Scripts/ImportKategorieBaum/baum.csv"):
        for match in re.finditer(rb"[A-Za-z0-9._%+-]+@([A-Za-z0-9.-]+)", content):
            if match.group(1).lower() not in (b"example.com", b"example.org", b"example.net"):
                yield {"path": path, "line": content[:match.start()].count(b"\n") + 1,
                       "category": "non-example-contact"}
    for category, pattern in signatures.items():
        for match in pattern.finditer(content):
            yield {"path": path, "line": content[:match.start()].count(b"\n") + 1, "category": category}


def main():
    """Inspect the working tree or all reachable Git blobs."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--history", action="store_true")
    args = parser.parse_args()
    root = pathlib.Path(subprocess.check_output(["git", "rev-parse", "--show-toplevel"], text=True).strip())
    signatures = patterns()
    findings = []
    count = 0
    if args.history:
        objects = subprocess.check_output(["git", "rev-list", "--objects", "--all"], cwd=root).splitlines()
        process = subprocess.Popen(["git", "cat-file", "--batch"], cwd=root, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        for entry in objects:
            object_id, _, name = entry.partition(b" ")
            process.stdin.write(object_id + b"\n")
            process.stdin.flush()
            header = process.stdout.readline().split()
            if len(header) != 3:
                raise RuntimeError("Cannot read Git object")
            content = process.stdout.read(int(header[2]))
            process.stdout.read(1)
            if header[1] != b"blob":
                continue
            count += 1
            for finding in scan(name.decode(errors="replace"), content, signatures):
                finding["object"] = object_id.decode()
                findings.append(finding)
        process.stdin.close()
        if process.wait() != 0:
            raise RuntimeError("Git object scan failed")
    else:
        names = subprocess.check_output(["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"], cwd=root).split(b"\0")
        for name in sorted(set(names)):
            if not name:
                continue
            relative = name.decode()
            path = root / relative
            if path.is_symlink():
                findings.append({"path": relative, "category": "symlink-review"})
                continue
            if not path.is_file():
                continue
            count += 1
            findings.extend(scan(relative, path.read_bytes(), signatures))
    print(json.dumps({"scope": "history" if args.history else "working-tree", "files_or_blobs": count, "findings": findings}, indent=2))
    return bool(findings)


if __name__ == "__main__":
    raise SystemExit(main())
