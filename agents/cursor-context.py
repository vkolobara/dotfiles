import json
from pathlib import Path

instructions = Path.home() / ".config/agents/AGENTS.md"
print(json.dumps({"additional_context": instructions.read_text(encoding="utf-8")}))
