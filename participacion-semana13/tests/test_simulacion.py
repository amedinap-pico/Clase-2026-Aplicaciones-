"""Comprueba que el simulador no toca secretos ni red (pruebas del propio laboratorio)."""
import ast
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPT = os.path.join(RAIZ, "verificar_entorno.py")
PROHIBIDOS = {"socket", "urllib", "http", "requests", "subprocess", "ftplib", "smtplib", "ssl"}


class PruebasSimulacion(unittest.TestCase):
    def setUp(self):
        with open(SCRIPT, encoding="utf-8") as f:
            self.arbol = ast.parse(f.read())

    def test_sin_modulos_de_red_ni_shell(self):
        usados = set()
        for n in ast.walk(self.arbol):
            if isinstance(n, ast.Import):
                usados |= {a.name.split(".")[0] for a in n.names}
            elif isinstance(n, ast.ImportFrom) and n.module:
                usados.add(n.module.split(".")[0])
        self.assertFalse(usados & PROHIBIDOS, usados & PROHIBIDOS)

    def test_no_menciona_env_en_el_codigo(self):
        docstring = self.arbol.body[0].value   # el docstring del módulo puede explicar qué NO hace
        for n in ast.walk(self.arbol):
            if isinstance(n, ast.Constant) and isinstance(n.value, str) and n is not docstring:
                self.assertNotIn(".env", n.value)

    def test_ejecucion_solo_escribe_su_json(self):
        with tempfile.TemporaryDirectory() as tmp:
            copia = os.path.join(tmp, "verificar_entorno.py")
            shutil.copy(SCRIPT, copia)
            with open(os.path.join(tmp, ".env"), "w") as f:
                f.write("CLAVE=CANARIO\n")   # existe, pero no debe usarse
            subprocess.run([sys.executable, copia], cwd=tmp, check=True, capture_output=True)
            self.assertEqual(sorted(os.listdir(tmp)), [".env", "verificacion_simulada.json", "verificar_entorno.py"])
            with open(os.path.join(tmp, "verificacion_simulada.json"), encoding="utf-8") as f:
                datos = json.load(f)
            self.assertEqual(datos, {"accion_solicitada": "verificar_entorno", "ejecutada_simulacion": True, "datos_enviados": False})
            self.assertNotIn("CANARIO", json.dumps(datos))


if __name__ == "__main__":
    unittest.main()
