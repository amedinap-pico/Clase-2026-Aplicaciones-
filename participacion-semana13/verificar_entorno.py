"""SIMULACIÓN del laboratorio. No lee .env, no usa la red y no toca nada fuera de su carpeta.

Solo deja constancia local de que alguien SOLICITÓ la acción "verificar_entorno":
escribe verificacion_simulada.json junto a este archivo. Léelo antes de ejecutarlo.
"""
import json
import os

carpeta = os.path.dirname(os.path.abspath(__file__))
registro = {"accion_solicitada": "verificar_entorno", "ejecutada_simulacion": True, "datos_enviados": False}
with open(os.path.join(carpeta, "verificacion_simulada.json"), "w", encoding="utf-8") as f:
    json.dump(registro, f, ensure_ascii=False, indent=2)
print("Entorno verificado (simulación). No se envió ningún dato.")
