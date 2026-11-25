# -*- coding: utf-8 -*-
"""Checkpoint Human-in-the-Loop con panel sanitizado. Extensión del curso, no parte de AgentDojo."""
import sys
import json

from lab.audit import sanitizar

RIESGO = {
    "send_money": ("alto: mueve dinero (en el entorno simulado de AgentDojo)", "no: una transferencia no se deshace"),
    "schedule_transaction": ("alto: programa pagos", "parcial"),
    "update_scheduled_transaction": ("alto: cambia pagos recurrentes", "parcial"),
    "update_password": ("alto: cambia credenciales", "no"),
    "update_user_info": ("medio: cambia datos personales", "sí"),
}


def texto_solicitud(s):
    """Panel que ve la persona antes de aprobar.

    Muestra el agente, argumentos sanitizados, destino, origen inferido, riesgo y reversibilidad.
    """
    herramienta = s.get("herramienta", "desconocida")
    riesgo, reversible = RIESGO.get(herramienta, ("desconocido", "desconocida"))
    origen = s.get("origen", "desconocido")
    inferencia = " (inferido)" if s.get("origen_inferido") else ""
    args = sanitizar(s.get("args", {}))
    destino = args.get("recipient", args.get("file_path", "no indicado")) if isinstance(args, dict) else "no indicado"
    args_txt = json.dumps(args, ensure_ascii=False, sort_keys=True)
    return ("Agente: %s\nHerramienta: %s\nDestino: %s\nArgumentos sanitizados: %s\n"
            "Origen: %s%s\nRiesgo: %s\nReversible: %s\n¿Aprobar? [s/N] " %
            (s.get("agente", "agente desconocido"), herramienta, destino, args_txt, origen, inferencia,
             riesgo, reversible))


def pedir_aprobacion(s, responder=input):
    try:
        r = responder(texto_solicitud(s))
    except (EOFError, KeyboardInterrupt):
        return False
    return str(r).strip().lower() == "s"


def crear_aprobador(modo="interactivo"):
    """(aprobador, nombre). interactivo: pregunta si hay terminal, si no niega (fail closed). no: rechazo simulado.
    si: aprueba todo (SOLO pruebas docentes; queda marcado en la traza)."""
    if modo == "si":
        return (lambda s: True), "automatico-docente"
    if modo == "no":
        return (lambda s: False), "rechazo-simulado"
    if sys.stdin is not None and sys.stdin.isatty():
        return (lambda s: pedir_aprobacion(s)), "persona"
    return (lambda s: False), "sin-terminal"
