#!/usr/bin/env python3
"""Apply theme keys that mise 2026.10.15 cannot merge into INI files."""

import argparse
import os
from pathlib import Path
import re
import shutil
import sys
import time


def set_key(text, key, value, section=None):
    """Replace only the selected key, preserving surrounding settings and comments."""
    if section is not None:
        header = re.search(rf"(?m)^\[{re.escape(section)}\][ \t]*\r?$", text)
        if header is None:
            return text.rstrip() + f"\n\n[{section}]\n{key}={value}\n"
        start = header.end()
        following = re.search(r"(?m)^\[", text[start:])
        end = start + following.start() if following else len(text)
        return text[:start] + set_key(text[start:end], key, value) + text[end:]

    pattern = rf"(?m)^[ \t]*{re.escape(key)}[ \t]*=.*$"
    if re.search(pattern, text):
        return re.sub(pattern, lambda _: f"{key}={value}", text)
    return text.rstrip() + f"\n{key}={value}\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    home = Path.home()
    config = Path(os.environ.get("XDG_CONFIG_HOME", home / ".config"))
    changes = {
        config / "bat/config": [(None, "--theme", '"kanagawa"')],
        config / "btop/btop.conf": [(None, "color_theme", '"kanagawa"')],
    }
    if sys.platform == "linux":
        changes.update({
            config / "qt6ct/qt6ct.conf": [
                ("Appearance", "color_scheme_path", str(config / "qt6ct/colors/matugen.conf")),
                ("Appearance", "custom_palette", "true"),
            ],
            config / "kdeglobals": [("General", "ColorScheme", "DankMatugen")],
        })

    backup = Path(os.environ.get("XDG_STATE_HOME", home / ".local/state")) / "dotfiles/backups" / time.strftime("kanagawa-%Y%m%d-%H%M%S")
    for path, keys in changes.items():
        before = path.read_text() if path.exists() else ""
        after = before
        for section, key, value in keys:
            after = set_key(after, key, value, section)
        update(path, before, after, config, backup, args.dry_run)

    if sys.platform == "linux":
        for version in ("3.0", "4.0"):
            path = config / f"gtk-{version}/gtk.css"
            if path.is_symlink() and path.resolve() == (path.parent / "dank-colors.css").resolve():
                continue
            before = path.read_text() if path.exists() else ""
            line = '@import url("dank-colors.css");'
            after = before if re.search(r"@import\s+url\(['\"]?dank-colors\.css['\"]?\);", before) else line + "\n" + before
            update(path, before, after, config, backup, args.dry_run)


def update(path, before, after, config, backup, dry_run):
    if before == after:
        return
    print(f"{'Would update' if dry_run else 'Updating'} {path}")
    if dry_run:
        return
    if path.exists():
        saved = backup / path.relative_to(config)
        saved.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, saved)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(after)


if __name__ == "__main__":
    main()
