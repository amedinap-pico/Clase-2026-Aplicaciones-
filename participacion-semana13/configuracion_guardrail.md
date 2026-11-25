# Configuracion del guardrail

- Configuracion: `.claude/settings.json` (configuracion de proyecto para Claude Code en Windows).
- Evento: `PreToolUse`, antes de ejecutar una llamada de herramienta.
- Matcher: `Read|Edit|Write|Bash|PowerShell`.
- Hook: `.claude/hooks/proteger_env.py`, iniciado con Python desde PowerShell.
- Politica: bloquear rutas `.env` y `.env.*`; bloquear comandos que mencionen esas rutas o ejecuten `verificar_entorno.py`.
- Codigos: 2 bloquea; 0 permite. `onFailure: block` solicita fallar cerrado si el hook falla o expira.
- Entradas que inspecciona: rutas (`file_path`, `path`, `filename`, `target`, `destination`) y campos de comando/script; en Bash y PowerShell revisa todos los textos de `tool_input`.

## Comprobaciones disponibles

1. `python .claude/hooks/probar_hook.py` prueba eventos JSON localmente y sin agente. Las pruebas basicas pasan: seis acciones prohibidas salen con codigo 2 y cuatro inocuas con codigo 0.
2. El JSON de `.claude/settings.json` se valido localmente.
3. No pude comprobar carga en una sesion Claude Code: esta actividad se ejecuto desde Codex y ese runtime no carga la configuracion de Claude. En Claude Code, abrir el proyecto y usar `/hooks` permite comprobar que el hook aparece como configuracion de proyecto; revisar tambien que la llamada bloqueada muestre el motivo. No se afirma que el hook estuviera activo en esta sesion.

La configuracion sigue la interfaz de hooks de Claude Code documentada actualmente: `PreToolUse` recibe JSON por stdin; codigo de salida 2 bloquea la llamada; `/hooks` permite inspeccionar los hooks configurados. En Windows se especifica el shell PowerShell. Referencias: https://code.claude.com/docs/en/hooks y https://code.claude.com/docs/en/settings

## Limites y segunda barrera

El matcher es textual y no interpreta el shell. Las tres llamadas inertes preparadas por el banco (ruta concatenada, comodin y variable intermedia) pasan. Otros alias, codificaciones, shell, herramientas MCP o procesos fuera del matcher pueden evadirlo. No es una proteccion universal.

Como segunda barrera, ejecutar el agente con permisos minimos y un sandbox del proyecto, sin secretos reales, con red saliente restringida y aprobacion humana para comandos. La politica de red debe evaluar por separado loopback y red local; bloquear Internet por si solo no los bloquea.
