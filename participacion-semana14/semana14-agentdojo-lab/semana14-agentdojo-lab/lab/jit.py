# -*- coding: utf-8 -*-
"""Token JIT con firma HMAC. Extensión educativa del curso, no un servicio de identidad."""
import hashlib
import hmac
import json
import math
import time
from numbers import Real

MAX_VIDA_SEG = 900
CAMPOS = ("subject", "resource", "actions", "constraints", "issued_at", "expires_at", "task_id")


def _firmar(cuerpo, clave):
    msg = json.dumps(cuerpo, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hmac.new(clave.encode("utf-8"), msg, hashlib.sha256).hexdigest()


def emitir(subject, resource, actions, constraints, task_id, minutos, clave, ahora=None):
    ahora = int(time.time() if ahora is None else ahora)
    cuerpo = {"subject": subject, "resource": resource, "actions": sorted(actions), "constraints": constraints,
              "issued_at": ahora, "expires_at": ahora + int(minutos * 60), "task_id": task_id}
    return dict(cuerpo, signature=_firmar(cuerpo, clave))


def validar(token, herramienta, args, clave, ahora=None):
    """Devuelve (True, "ok") o (False, motivo).

    Rechaza, en este orden, cuando:
      1. falta algún campo de CAMPOS o "signature", o la firma no coincide (_firmar + hmac.compare_digest)
      2. la vida del token (expires_at - issued_at) supera MAX_VIDA_SEG
      3. el token venció (ahora >= expires_at)
      4. la herramienta no está en token["actions"]
      5. si es send_money: el destinatario no está en constraints["recipients"] (sin distinguir mayúsculas)
         o el monto supera constraints["max_amount"] (o no es numérico)
    """
    if not isinstance(token, dict) or any(c not in token for c in CAMPOS) or "signature" not in token:
        return False, "token incompleto"
    if not isinstance(token.get("signature"), str):
        return False, "firma inválida"
    cuerpo = {c: token[c] for c in CAMPOS}
    try:
        firma_valida = hmac.compare_digest(_firmar(cuerpo, clave), token["signature"])
    except (TypeError, ValueError, OverflowError):
        return False, "firma inválida"
    if not firma_valida:
        return False, "firma inválida"

    emitido, vence = token["issued_at"], token["expires_at"]
    if (not isinstance(emitido, Real) or isinstance(emitido, bool)
            or not isinstance(vence, Real) or isinstance(vence, bool)
            or not math.isfinite(float(emitido)) or not math.isfinite(float(vence))):
        return False, "tiempos inválidos"
    vida = vence - emitido
    if vida <= 0 or vida > MAX_VIDA_SEG:
        return False, "vida del token inválida o superior al máximo"

    ahora = time.time() if ahora is None else ahora
    if not isinstance(ahora, Real) or isinstance(ahora, bool) or not math.isfinite(float(ahora)):
        return False, "hora inválida"
    if ahora < emitido:
        return False, "token aún no vigente"
    if ahora >= vence:
        return False, "token vencido"

    acciones = token["actions"]
    if not isinstance(acciones, (list, tuple)) or any(not isinstance(a, str) for a in acciones):
        return False, "acciones inválidas"
    if herramienta not in acciones:
        return False, "herramienta fuera del alcance"

    if herramienta == "send_money":
        restricciones = token["constraints"]
        if not isinstance(restricciones, dict):
            return False, "restricciones inválidas"
        destinatarios = restricciones.get("recipients")
        destino = args.get("recipient") if isinstance(args, dict) else None
        if (not isinstance(destinatarios, (list, tuple)) or not isinstance(destino, str)
                or any(not isinstance(x, str) for x in destinatarios)):
            return False, "destinatario fuera del alcance"
        if destino.casefold() not in {x.casefold() for x in destinatarios}:
            return False, "destinatario fuera del alcance"
        monto = args.get("amount") if isinstance(args, dict) else None
        maximo = restricciones.get("max_amount")
        if (not isinstance(monto, Real) or isinstance(monto, bool)
                or not isinstance(maximo, Real) or isinstance(maximo, bool)
                or not math.isfinite(float(monto)) or not math.isfinite(float(maximo))
                or monto > maximo):
            return False, "monto fuera del alcance"

    return True, "ok"
