"""Bundle shared Lua and selected sample data into one TTS Global script."""

import json
from pathlib import Path


def lua_string(text):
    marker = "="
    while "]" + marker + "]" in text:
        marker += "="
    return "[" + marker + "[" + text + "]" + marker + "]"


def main():
    root = Path(__file__).resolve().parents[1]
    sections = [
        "-- GENERATED: python tools/build_importer.py\n"
        "-- Paste this file once into TTS Global. Do not edit the generated file.\n"
        "-- Import is explicit; onLoad never creates cards.\n"
    ]
    for variable, path in [("SAMPLE_CARDS", "card/samples.json"),
                           ("POINT_SYSTEM", "card/points.json")]:
        data = json.loads((root / path).read_text(encoding="utf-8"))
        payload = json.dumps(data, ensure_ascii=False, separators=(",", ":"))
        sections.append(f"local {variable} = JSON.decode({lua_string(payload)})\n")
    locale = (root / "card/localization.lua").read_text(encoding="utf-8")
    resources = (root / "mark/marker_resources.lua").read_text(encoding="utf-8")
    marker_script = locale + "\n" + resources + "\n" + (root / "mark/adjustable_marker.lua").read_text(encoding="utf-8")
    sections.append("local MARKER_OBJECT_SCRIPT = " + lua_string(marker_script) + "\n")
    for path in ["card/localization.lua", "card/card_common.lua", "mark/marker_resources.lua", "ground/field_statistics.lua",
                 "ground/marker_tools.lua", "ground/card_importer.lua"]:
        sections.append((root / path).read_text(encoding="utf-8"))
    output = root / "ground/import_cards.lua"
    output.write_text("\n".join(sections), encoding="utf-8")
    print(f"Built {output}")


if __name__ == "__main__":
    main()
