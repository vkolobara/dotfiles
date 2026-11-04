import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from apply import set_key


class ThemeDeploymentTests(unittest.TestCase):
    def test_ini_merge_preserves_other_sections_and_comments(self):
        before = "# local\n[Appearance]\nicon_theme=Adwaita\ncustom_palette=false\n\n[Other]\nx=1\n"
        after = set_key(before, "custom_palette", "true", "Appearance")
        self.assertEqual(after, before.replace("custom_palette=false", "custom_palette=true"))
        self.assertEqual(set_key(after, "custom_palette", "true", "Appearance"), after)

    @unittest.skipUnless(sys.platform == "linux", "GTK deployment is Linux-only")
    def test_deployment_preserves_gtk_symlink_and_is_idempotent(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            config = root / "config"
            gtk = config / "gtk-3.0"
            gtk.mkdir(parents=True)
            generated = gtk / "dank-colors.css"
            generated.write_text("/* generated */\n")
            (gtk / "gtk.css").symlink_to("dank-colors.css")
            btop = config / "btop/btop.conf"
            btop.parent.mkdir()
            btop.write_text('# local\ncolor_theme = "TTY"\nvim_keys = true\n')
            env = dict(os.environ, XDG_CONFIG_HOME=str(config), XDG_STATE_HOME=str(root / "state"))
            command = [sys.executable, str(Path(__file__).with_name("apply.py"))]

            subprocess.run(command, env=env, check=True, capture_output=True)
            self.assertEqual(generated.read_text(), "/* generated */\n")
            self.assertTrue((gtk / "gtk.css").is_symlink())
            self.assertIn("vim_keys = true", btop.read_text())
            backups = list((root / "state/dotfiles/backups").rglob("btop.conf"))
            self.assertEqual(len(backups), 1)
            self.assertIn('color_theme = "TTY"', backups[0].read_text())

            second = subprocess.run(command, env=env, check=True, capture_output=True, text=True)
            self.assertEqual(second.stdout, "")


if __name__ == "__main__":
    unittest.main()
