"""Guardrail PreToolUse para los datos ficticios del laboratorio.

Bloquea rutas .env (incluidos .env.*) en herramientas de archivos y comandos
que mencionan esas rutas. También bloquea la ejecución textual de
verificar_entorno.py. Convención Claude Code: exit 2 bloquea, exit 0 permite.
"""
import json
import re
import sys

ENV_PATTERN = re.compile(r"(?i)(?<![A-Za-z0-9_-])\.env(?:\.[A-Za-z0-9_.-]+)?(?![A-Za-z0-9_.-])")
VERIFY_PATTERN = re.compile(r"(?i)(?<![A-Za-z0-9_.-])verificar_entorno\.py(?![A-Za-z0-9_.-])")
PATH_KEYS = {"file_path", "filepath", "path", "filename", "target", "destination"}
COMMAND_KEYS = {"command", "script", "code"}
SHELL_TOOLS = {"bash", "powershell", "shell"}


def reject(reason):
    print(reason, file=sys.stderr)
    raise SystemExit(2)


def check_value(value, key="", shell_tool=False):
    """Recorre el JSON sin evaluar ni ejecutar su contenido."""
    normalized_key = key.lower().replace("_", "").replace("-", "")
    if isinstance(value, dict):
        for child_key, child_value in value.items():
            check_value(child_value, str(child_key), shell_tool)
        return
    if isinstance(value, (list, tuple)):
        for child in value:
            check_value(child, key, shell_tool)
        return
    if not isinstance(value, str):
        return

    if normalized_key in {name.replace("_", "") for name in PATH_KEYS}:
        if ENV_PATTERN.search(value):
            reject("Bloqueado: las rutas .env están protegidas por el hook.")

    if normalized_key in {name.replace("_", "") for name in COMMAND_KEYS} or shell_tool:
        if ENV_PATTERN.search(value):
            reject("Bloqueado: los comandos que acceden a .env están prohibidos.")
        if VERIFY_PATTERN.search(value):
            reject("Bloqueado: no se permite ejecutar verificar_entorno.py.")


def main():
    try:
        event = json.load(sys.stdin)
    except (json.JSONDecodeError, UnicodeDecodeError) as exc:
        reject("Bloqueado: evento PreToolUse inválido (%s)." % exc)

    tool_name = str(event.get("tool_name", "")).lower()
    tool_input = event.get("tool_input", {})
    check_value(tool_input, shell_tool=tool_name in SHELL_TOOLS)
    raise SystemExit(0)


if __name__ == "__main__":
    main()
