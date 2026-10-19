"""Apply the built Global without reloading; back up small runtime strings.

Run after build_importer.py, with TTS's External Editor API enabled.
Reading the game requires explicit --capture-only; changing it requires --apply.
Only this project's Global is replaced. A running import blocks deployment.
The game and editor cache may differ: never deploy messageID=0's old source.
"""

import argparse
from datetime import datetime
import json
from pathlib import Path
import socket
import time

from build_importer import lua_string


ROOT = Path(__file__).resolve().parents[1]


def request(payload, timeout=30):
    with socket.socket() as listener:
        listener.bind(("127.0.0.1", 39998))
        listener.listen()
        with socket.create_connection(("127.0.0.1", 39999), 5) as client:
            client.sendall(json.dumps(payload).encode("ascii"))
            client.shutdown(socket.SHUT_WR)
            deadline = time.monotonic() + timeout
            while time.monotonic() < deadline:
                listener.settimeout(max(.1, deadline - time.monotonic()))
                connection, _ = listener.accept()
                with connection:
                    connection.settimeout(5)
                    content = b""
                    while True:
                        part = connection.recv(65536)
                        if not part:
                            break
                        content += part
                        try:
                            message = json.loads(content)
                            break
                        except (ValueError, UnicodeError):
                            continue
                message = json.loads(content)
                if message.get("messageID") == 3 and message.get("guid") == payload.get("guid", "-1"):
                    raise RuntimeError(message.get("error", str(message)))
                if payload["messageID"] in (0, 1) and message.get("messageID") == 1:
                    return message
                if message.get("messageID") == 5 and message.get("returnID") == payload.get("returnID"):
                    return message.get("returnValue")
            raise TimeoutError("TTS did not reply")


def execute(script):
    return request({"messageID": 3, "guid": "-1", "returnID": 19001, "script": script})


def snapshot():
    # Return large native strings directly through the external editor protocol.
    # NEVER run the Lua Unicode encoder over source or a complete scene: its
    # per-character traversal blocked TTS's main thread on 2026-10-19.
    metadata = json.loads(execute("""
return JSON.encode({
    importBusy = UI.getAttribute("lc_import_button", "interactable") == "false",
    panel = UI.getAttribute("lc_import_panel", "active") == "true" and "import"
        or UI.getAttribute("lc_field_panel", "active") == "true" and "field"
        or UI.getAttribute("lc_marker_panel", "active") == "true" and "marker"
        or UI.getAttribute("lc_locale_panel", "active") == "true" and "locale" or ""})
"""))
    result = {key: metadata[key] for key in ("importBusy", "panel")}
    result["script"] = execute("return Global.getLuaScript()")
    result["ui"] = execute("return UI.getXml()")
    result["state"] = execute("return onSave()")
    return result


def write_json(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding="utf-8")


def same_script(left, right):
    # External Editor omits the final line terminator; retain every actual line.
    return left.splitlines() == right.splitlines()


def verify_saved_scene(native):
    # Only ASCII GUIDs and numeric transforms. No card text, Lua source, or
    # recursive object data is serialized in the game.
    live = json.loads(execute("""
local rows = {}
for _, o in ipairs(getObjects()) do
    table.insert(rows, {guid=o.getGUID(), p=o.getPosition(), r=o.getRotation(), s=o.getScale()})
end
return JSON.encode(rows)
"""))
    saved = {o["GUID"]: o for o in native["ObjectStates"]}
    if set(saved) != {o["guid"] for o in live}:
        raise RuntimeError("Objects changed after manual save; save the game again before reloading")
    for obj in live:
        transform = saved[obj["guid"]]["Transform"]
        for group, prefix in (("p", "pos"), ("r", "rot"), ("s", "scale")):
            for axis in "xyz":
                delta = abs(obj[group][axis] - transform[prefix + axis.upper()])
                if group == "r":
                    delta = min(delta % 360, 360 - delta % 360)
                if delta > .01:
                    raise RuntimeError(f"Object {obj['guid']} moved after manual save; save again before reloading")


def finalize_save(native_file, native, source, after, states, backup):
    native.update(LuaScript=source, LuaScriptState=after["state"], XmlUI=after["ui"])
    by_guid = {s["guid"]: s for s in states if s["guid"] != "-1"}
    for obj in native["ObjectStates"]:
        if obj["GUID"] in by_guid:
            obj["LuaScript"] = by_guid[obj["GUID"]]["script"]
    write_json(backup / "native-save.json", native)
    write_json(native_file, native)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--save-dir", type=Path, required=True, help="TTS Saves directory with a current autosave")
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--capture-only", action="store_true", help="Back up live data without changing the game")
    mode.add_argument("--apply", action="store_true", help="Explicitly authorize hot deployment without reloading")
    mode.add_argument("--export-save", action="store_true", help="Copy a native autosave only after its source matches the live Global")
    mode.add_argument("--reload", action="store_true", help="Explicitly authorized Save & Play after a fresh in-game manual save")
    parser.add_argument("--saved-game", type=Path, help="Fresh manual save to back up and finalize with the new scripts")
    args = parser.parse_args()
    # Read the native environment before changing anything; fail early if absent.
    autosaves = list(args.save_dir.glob("TS_AutoSave*.json"))
    if not autosaves:
        parser.error("No native autosave found; save the current game first")
    if args.reload and not args.saved_game:
        parser.error("--reload requires --saved-game from a fresh in-game manual save")
    native_file = args.saved_game if args.reload else max(autosaves, key=lambda p: p.stat().st_mtime)
    native = json.loads(native_file.read_text(encoding="utf-8-sig"))
    before = snapshot()
    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = ROOT / ".tts-backups" / (stamp + "-sync")
    backup.mkdir(parents=True)
    write_json(backup / "before.json", before)
    write_json(backup / "native-template.json", native)
    write_json(backup / "restore-message.json", {"messageID": 1, "scriptStates": [
        {"guid": "-1", "name": "Global", "script": before["script"], "ui": before["ui"]}]})
    if args.capture_only:
        print(f"Captured {backup}")
        return
    if args.export_save:
        if not same_script(native.get("LuaScript", ""), before["script"]):
            raise RuntimeError("Native autosave still contains old source; save in TTS or wait for its next autosave")
        native["SaveName"] = "LoveCa markers " + stamp
        save = args.save_dir / ("Loveca_" + stamp + ".json")
        write_json(save, native)
        write_json(backup / "native-save.json", native)
        print(f"Verified native save: {save}\nBackup: {backup}")
        return
    if before["importBusy"]:
        raise RuntimeError("Import in progress; wait for completion before synchronizing")
    source = (ROOT / "ground/import_cards.lua").read_text(encoding="utf-8")
    if args.reload:
        verify_saved_scene(native)
        # This path is intentionally separate from hot preview. Global's editor
        # cache stays old after setLuaScript, and native autosaves use that cache.
        # Save & Play updates it but reloads the last native scene: save first.
        marker_source = (ROOT / "card/localization.lua").read_text(encoding="utf-8") + "\n" + (ROOT / "mark/marker_resources.lua").read_text(encoding="utf-8") + "\n" + (ROOT / "mark/adjustable_marker.lua").read_text(encoding="utf-8")
        states = [{"guid": "-1", "name": "Global", "script": source, "ui": before["ui"]}]
        for obj in native["ObjectStates"]:
            if obj.get("Name") == "Custom_Tile" and "loveca.marker" in obj.get("Memo", ""):
                memo = json.loads(obj["Memo"])
                if memo.get("schema") == "loveca.marker" and memo.get("schema_version") == 1:
                    states.append({"guid": obj["GUID"], "name": obj.get("Nickname", ""),
                        "script": marker_source, "ui": obj.get("XmlUI", "")})
        message = {"messageID": 1, "scriptStates": states}
        # Refresh the editor's scene checkpoint before Save & Play. Reading
        # runtime source alone does not refresh that checkpoint; an older one
        # can resurrect objects removed before the user's latest manual save.
        # Never substitute the returned cached source for the built source.
        checkpoint = request({"messageID": 0})
        write_json(backup / "editor-before.json", checkpoint)
        write_json(backup / "installed-message.json", message)
        print(f"Recovery prepared: {backup}", flush=True)
        request(message, timeout=60)
        # Read strings directly. Never encode a whole scene or script in Lua.
        installed = execute("return Global.getLuaScript()")
        cached = request({"messageID": 0})
        cached_global = next(s for s in cached["scriptStates"] if s["guid"] == "-1")
        if not same_script(installed, source) or not same_script(cached_global["script"], source):
            raise RuntimeError(f"Runtime/editor source differs after reload; recovery: {backup}")
        live_guids = json.loads(execute("""
local guids = {}
for _, object in ipairs(getObjects()) do table.insert(guids, object.getGUID()) end
return JSON.encode(guids)
"""))
        if set(live_guids) != {obj["GUID"] for obj in native["ObjectStates"]}:
            raise RuntimeError(f"Reloaded scene differs from the explicit save; do not finalize it. Recovery: {backup}")
        write_json(backup / "editor-after.json", cached)
        after = snapshot()
        write_json(backup / "after.json", after)
        # Finalize only the user's newly created repair save. Preserve all
        # native scene data, while storing verified Global/object source text.
        finalize_save(native_file, native, source, after, states, backup)
        print(f"Reloaded; runtime/editor/native save agree.\nSave: {native_file}\nRecovery: {backup}")
        return
    result = execute(source + "\nonLoad(" + lua_string(before["state"]) + ")\n"
        + "Global.setLuaScript(" + lua_string(source) + ")\n"
        + "Wait.frames(function() showLovecaPanel("
        + (lua_string(before["panel"]) if before["panel"] else "nil") + ") end, 8)\n"
        + 'return "loveca-synchronized"')
    after = snapshot()
    if not same_script(after["script"], source):
        raise RuntimeError(f"Global source differs after sync; recovery is in {backup}")
    write_json(backup / "after.json", after)
    write_json(backup / "installed-message.json", {"messageID": 1, "scriptStates": [
        {"guid": "-1", "name": "Global", "script": source, "ui": after["ui"]}]})
    # Do not synthesize a scene by mixing stale autosave objects with live state.
    # TTS's own next save must contain this source before --export-save succeeds.
    print(f"{result}\nRecovery: {backup}\nSave in TTS or wait for autosave, then run --export-save.")


if __name__ == "__main__":
    main()
