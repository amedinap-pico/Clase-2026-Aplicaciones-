"""Plantilla del guardrail (PreToolUse). Cópiala como proteger_env.py y complétala.

El agente envía el evento como JSON por stdin. Campos útiles: tool_name y tool_input
(p. ej. file_path para lecturas y edición, command para el shell). Confirma los nombres
reales en la documentación de TU agente.

Convención del agente de clase: exit 2 = bloquear la llamada (el mensaje de stderr llega al agente);
exit 0 = permitir.

Nota: formato descrito según la documentación de hooks de Claude Code consultada en noviembre de 2026 (tool_name/tool_input y exit 2 en PreToolUse).
Confirma tu versión y la documentación vigente de tu agente. Es un control parcial: no cubre todas las rutas de ejecución.
"""
import json
import sys

evento = json.load(sys.stdin)
herramienta = evento.get("tool_name", "")
datos = evento.get("tool_input", {})

# TODO 1: decide qué cadenas o rutas son sensibles (.env, verificar_entorno.py, ...).
# TODO 2: revisa TODOS los campos relevantes de tool_input, no solo uno.
# TODO 3: si hay coincidencia, escribe el motivo en stderr y termina con exit 2.

sys.exit(0)   # por ahora permite todo: las pruebas de probar_hook.py deben FALLAR hasta que lo completes
