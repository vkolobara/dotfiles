"""Merge desktop font settings without replacing theme or application settings."""

import configparser
import os
import shutil
from datetime import datetime
from pathlib import Path


def main():
    config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    state_home = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
    backup = state_home / "dotfiles/backups" / datetime.now().strftime("fonts-%Y%m%d-%H%M%S-%f")
    qt_font = '"Adwaita Sans,11,-1,5,50,0,0,0,0,0"'
    qt_mono_font = '"SauceCodePro Nerd Font Mono,11,-1,5,50,0,0,0,0,0"'
    settings = {
        "gtk-3.0/settings.ini": {"Settings": {"gtk-font-name": "Adwaita Sans 11"}},
        "gtk-4.0/settings.ini": {"Settings": {"gtk-font-name": "Adwaita Sans 11"}},
        "qt5ct/qt5ct.conf": {"Fonts": {"general": qt_font, "fixed": qt_mono_font}},
        "qt6ct/qt6ct.conf": {"Fonts": {"general": qt_font, "fixed": qt_mono_font}},
    }
    for relative, sections in settings.items():
        path = config_home / relative
        config = configparser.ConfigParser(interpolation=None)
        config.optionxform = str
        if path.exists():
            with path.open() as source:
                config.read_file(source)
        changed = False
        for section, values in sections.items():
            if not config.has_section(section):
                config.add_section(section)
            for key, value in values.items():
                if config.get(section, key, fallback=None) != value:
                    config.set(section, key, value)
                    changed = True
        if not changed:
            continue
        if path.exists():
            saved = backup / relative
            saved.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, saved)
            print(f"Backup: {saved}")
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open("w") as target:
            config.write(target, space_around_delimiters=False)
        print(f"Updated: {path}")


if __name__ == "__main__":
    main()
