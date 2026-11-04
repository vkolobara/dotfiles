"""Check that applying fonts preserves other desktop settings."""

import configparser
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


class DesktopFontsTest(unittest.TestCase):
    def test_merge_backup_and_reapply(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            config_home = root / "config"
            state_home = root / "state"
            paths = [
                config_home / "gtk-3.0/settings.ini",
                config_home / "gtk-4.0/settings.ini",
                config_home / "qt5ct/qt5ct.conf",
                config_home / "qt6ct/qt6ct.conf",
            ]
            original = "[Appearance]\nicon_theme=KeepMe\n[Custom]\nValue=100%\n"
            for path in paths:
                path.parent.mkdir(parents=True)
                path.write_text(original)
            env = dict(os.environ, XDG_CONFIG_HOME=str(config_home), XDG_STATE_HOME=str(state_home))
            command = [sys.executable, str(Path(__file__).with_name("desktop.py"))]
            subprocess.run(command, env=env, check=True, capture_output=True)
            for path in paths:
                config = configparser.ConfigParser(interpolation=None)
                config.read(path)
                self.assertEqual(config["Appearance"]["icon_theme"], "KeepMe")
                self.assertEqual(config["Custom"]["value"], "100%")
                if path.suffix == ".ini":
                    self.assertEqual(config["Settings"]["gtk-font-name"], "Adwaita Sans 11")
                else:
                    self.assertTrue(config["Fonts"]["fixed"].startswith('"SauceCodePro Nerd Font Mono,'))
            backups = [path for path in state_home.rglob("*") if path.is_file()]
            self.assertEqual(len(backups), 4)
            self.assertTrue(all(path.read_text() == original for path in backups))
            first = {path: path.read_bytes() for path in paths}
            rerun = subprocess.run(command, env=env, check=True, capture_output=True)
            self.assertEqual(rerun.stdout, b"")
            self.assertEqual(first, {path: path.read_bytes() for path in paths})
            self.assertEqual(backups, [path for path in state_home.rglob("*") if path.is_file()])

    def test_create_missing_settings(self):
        with tempfile.TemporaryDirectory() as directory:
            env = dict(os.environ, XDG_CONFIG_HOME=directory, XDG_STATE_HOME=directory)
            subprocess.run([sys.executable, str(Path(__file__).with_name("desktop.py"))], env=env, check=True, capture_output=True)
            self.assertTrue((Path(directory) / "gtk-3.0/settings.ini").is_file())
            self.assertTrue((Path(directory) / "qt6ct/qt6ct.conf").is_file())


if __name__ == "__main__":
    unittest.main()
