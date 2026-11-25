# -*- coding: utf-8 -*-
"""Motor de políticas allow/ask/deny.

EXTENSIÓN DEL CURSO: AgentDojo no trae este motor. Se inserta en su pipeline mediante un ToolsExecutor vigilado
(lab/guardian.py): el modelo solo PROPONE la llamada; esta función decide antes de que la herramienta se ejecute.
"""
import json
import math
from numbers import Real
from pathlib import Path

from lab.escenario import HERRAMIENTAS_BANKING

DECISIONES = ("allow", "ask", "deny")


def cargar_politica(ruta):
    with open(Path(ruta), encoding="utf-8") as f:
        pol = json.load(f)
    if pol.get("default") not in DECISIONES:
        raise ValueError("la política necesita 'default' en allow/ask/deny")
    return pol


def _cumple(cond, args):
    """¿Los argumentos cumplen las condiciones 'when' de una regla?

    Las condiciones presentes deben cumplirse todas; una condición ausente no restringe.
    Soporta destinatarios permitidos, monto máximo y rutas de archivo permitidas.
    """
    if not isinstance(cond, dict) or not isinstance(args, dict):
        return False

    if "recipient_in" in cond:
        permitidos = cond["recipient_in"]
        destino = args.get("recipient")
        if (not isinstance(permitidos, (list, tuple)) or not isinstance(destino, str)
                or any(not isinstance(x, str) for x in permitidos)):
            return False
        if destino.casefold() not in {x.casefold() for x in permitidos}:
            return False

    if "max_amount" in cond:
        monto, maximo = args.get("amount"), cond["max_amount"]
        if (not isinstance(monto, Real) or isinstance(monto, bool)
                or not isinstance(maximo, Real) or isinstance(maximo, bool)):
            return False
        if not math.isfinite(float(monto)) or not math.isfinite(float(maximo)) or monto > maximo:
            return False

    if "file_in" in cond:
        permitidos = cond["file_in"]
        archivo = args.get("file_path")
        if not isinstance(permitidos, (list, tuple)) or not isinstance(archivo, str):
            return False
        if any(not isinstance(x, str) for x in permitidos) or archivo not in permitidos:
            return False

    # Una condición desconocida o mal formada nunca amplía un permiso.
    if set(cond) - {"recipient_in", "max_amount", "file_in"}:
        return False
    return True


def _regla_aplica(regla, herramienta, args):
    return regla.get("tool") == herramienta and _cumple(regla.get("when", {}), args)


def decidir(politica, herramienta, args):
    """Devuelve (decision, indice_regla|None). La primera regla que aplica decide.

    Herramientas fuera del benchmark y decisiones inválidas se deniegan.
    """
    if herramienta not in HERRAMIENTAS_BANKING:
        return "deny", None
    for i, regla in enumerate(politica.get("rules", [])):
        if _regla_aplica(regla, herramienta, args):
            decision = regla.get("decision", "deny")
            return (decision if decision in DECISIONES else "deny"), i
    decision = politica.get("default", "deny")
    return (decision if decision in DECISIONES else "deny"), None
