"""Run vanilla 26.3 against the installable ZIP in a disposable, offline GameTest world."""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import zipfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("version_json", type=Path, help="Local 26.3 launcher version JSON (with a sibling client jar)")
    parser.add_argument("--java", default="java", help="Java 25 executable")
    parser.add_argument("--publish", type=Path, help="Copy the verified ZIP to this location")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    meta = args.version_json.resolve()
    libdir = meta.parents[2] / "libraries"
    jars = [meta.with_suffix(".jar")]
    for lib in json.loads(meta.read_text(encoding="utf-8-sig"))["libraries"]:
        artifact = lib.get("downloads", {}).get("artifact", {}).get("path")
        if artifact and (libdir / artifact).is_file():
            jars.append(libdir / artifact)
    with tempfile.TemporaryDirectory(prefix="sulfur-gametest-") as tmp:
        work = Path(tmp)
        packs = work / "packs"
        fixture = packs / "fixture"
        ns = fixture / "data" / "sc_test"
        for folder in ("test_instance", "test_environment", "function"):
            (ns / folder).mkdir(parents=True)
        pack = packs / "sulfur-dodge.zip"
        with zipfile.ZipFile(pack, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
            for f in [root / "pack.mcmeta", root / "README.md", root / "DESIGN.md", *sorted((root / "data").rglob("*"))]:
                if f.is_file():
                    z.write(f, f.relative_to(root).as_posix())
        with zipfile.ZipFile(pack) as z:
            if z.testzip() is not None:
                raise ValueError("Invalid datapack ZIP")
            menu = json.loads(z.read("data/sc/dialog/settings.json"))
            if [b["action"]["command"] for b in menu["actions"]] != [f"trigger sc_cfg set {i}" for i in (1, 2, 3)]:
                raise ValueError("Lectern must only offer edit, help and restore defaults")
        shutil.copyfile(root / "pack.mcmeta", fixture / "pack.mcmeta")
        (ns / "test_instance" / "rules.json").write_text(json.dumps({
            "type": "minecraft:function", "environment": "sc_test:rules", "function": "sc_test:player",
            "structure": "minecraft:empty", "max_ticks": 20, "setup_ticks": 40,
        }), encoding="utf-8")
        (ns / "test_environment" / "rules.json").write_text(json.dumps({
            "type": "minecraft:function", "setup": "sc_test:setup",
        }), encoding="utf-8")
        (ns / "function" / "setup.mcfunction").write_text(
            "function sc:install\nschedule function sc_test:rules 30t\n", encoding="utf-8")
        rules = (root / "tests" / "match_rules.mcfunction").read_text(encoding="utf-8").splitlines()
        fail = "run scoreboard players add #errors sc_var 1"
        (ns / "function" / "rules.mcfunction").write_text("\n".join(
            (line.replace(fail, f"run say SC_ASSERT_LINE_{n}") + "\n" if line.endswith(fail) else "") + line
            for n, line in enumerate(rules, 1)
        ), encoding="utf-8")
        cp = os.pathsep.join(map(str, jars)).replace("\\", "\\\\")
        (work / "classpath.args").write_text(f'-classpath\n"{cp}"', encoding="utf-8")
        run = subprocess.run([args.java, "-Xmx1G", "@classpath.args", str(root / "tests" / "PlayerMechanicsTest.java"),
                              "--packs", str(packs), "--tests", "sc_test:rules", "--universe", str(work / "world")],
                             cwd=work, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=160)
        log = run.stdout.decode("utf-8", errors="replace")
        if run.returncode or "SC_RULES_OK" not in log or "SC_PLAYER_OK" not in log or "SC_RULES_FAILED" in log or "Failed to load function" in log:
            raise SystemExit(log[-10000:].encode("ascii", "backslashreplace").decode())
        if args.publish:
            shutil.copyfile(pack, args.publish)
        print("Vanilla GameTest passed: spear pose, native Lunge cost/regen, ball and wall rules, and immediate lobby return.")


if __name__ == "__main__":
    main()
