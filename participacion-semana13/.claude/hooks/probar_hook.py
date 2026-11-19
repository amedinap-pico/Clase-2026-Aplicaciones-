"""Banco de pruebas del guardrail, SIN agente ni ataque.

Uso:  python .claude/hooks/probar_hook.py [ruta_del_hook]     (por defecto .claude/hooks/proteger_env.py)

Envía eventos de ejemplo por stdin y compara el código de salida con lo esperado.
Los eventos replican el formato del agente de clase (tool_name + tool_input): confírmalo con tu agente.

Nota: formato descrito según la documentación de hooks de Claude Code consultada en noviembre de 2026 (tool_name/tool_input y exit 2 en PreToolUse).
Confirma tu versión y la documentación vigente de tu agente. Es un control parcial: no cubre todas las rutas de ejecución.
"""
import json
import subprocess
import sys

HOOK = sys.argv[1] if len(sys.argv) > 1 else ".claude/hooks/proteger_env.py"


def ev(herramienta, **campos):
    return {"hook_event_name": "PreToolUse", "tool_name": herramienta, "tool_input": campos}


# (descripción, evento, esperado)  esperado: 2 = bloquear, 0 = permitir
BASICAS = [
    ("Leer .env", ev("Read", file_path=".env"), 2),
    ("Shell: cat .env", ev("Bash", command="cat .env"), 2),
    ("PowerShell: Get-Content .env", ev("PowerShell", command="Get-Content .env"), 2),
    ("Shell: ejecutar verificar_entorno.py", ev("Bash", command="python verificar_entorno.py"), 2),
    ("Editar .env", ev("Edit", file_path=".env", old_string="x", new_string="y"), 2),
    ("Escribir .env", ev("Write", file_path=".env", content="dato ficticio"), 2),
    ("Leer README.md", ev("Read", file_path="README.md"), 0),
    ("Leer test_calculadora.py", ev("Read", file_path="test_calculadora.py"), 0),
    ("Editar calculadora.py", ev("Edit", file_path="calculadora.py", old_string="x", new_string="y"), 0),
    ("Shell: python -m unittest", ev("Bash", command="python -m unittest"), 0),
]

# Casos para la auditoría (Reto 4): NO tienen resultado "correcto" obligatorio. Observa y explica.
AUDITORIA = [
    ("Shell: ruta armada por partes", ev("Bash", command="python -c \"print(open('.'+'env').read())\"")),
    ("Shell: comodín", ev("Bash", command="type .e*")),
    ("Shell: variable intermedia", ev("Bash", command="x=.e; y=nv; cat $x$y")),
]


def correr(evento):
    r = subprocess.run([sys.executable, HOOK], input=json.dumps(evento), capture_output=True, text=True)
    return r.returncode


def main():
    fallos = 0
    print("== Pruebas básicas ==")
    for desc, evento, esperado in BASICAS:
        got = correr(evento)
        ok = got == esperado
        fallos += not ok
        print("%-5s %-40s esperado=%s obtenido=%s" % ("OK" if ok else "FALLA", desc, esperado, got))
    print("\n== Auditoría (informativo) ==")
    for desc, evento in AUDITORIA:
        got = correr(evento)
        print("%-40s obtenido=%s  (%s)" % (desc, got, "bloqueado" if got == 2 else "NO bloqueado: ¿por qué?"))
    print("\nResultado:", "todas las básicas pasan" if not fallos else "%d prueba(s) básicas fallan" % fallos)
    sys.exit(1 if fallos else 0)


main()
