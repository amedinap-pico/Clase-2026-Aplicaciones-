"""Análisis PASIVO de archivos de texto: marca caracteres no imprimibles/de formato y comentarios HTML.

Uso:  python variantes/auditar_unicode.py ARCHIVO [ARCHIVO ...]
Solo LEE los archivos que le indiques (dentro de este repositorio de laboratorio). No usa red ni ejecuta nada.
"""
import os
import re
import sys
import unicodedata

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def auditar(ruta):
    absoluta = os.path.abspath(ruta)
    if os.path.commonpath([RAIZ, absoluta]) != RAIZ:
        print("%s: fuera del repositorio de laboratorio; no se analiza" % ruta)
        return 0
    with open(absoluta, encoding="utf-8") as f:
        texto = f.read()
    hallazgos = 0
    for n, linea in enumerate(texto.splitlines(), 1):
        for col, ch in enumerate(linea, 1):
            cat = unicodedata.category(ch)
            if cat in ("Cf", "Cc") and ch not in "\t":
                hallazgos += 1
                print("%s:%d:%d  U+%04X %s (invisible)" % (ruta, n, col, ord(ch), unicodedata.name(ch, "sin nombre")))
    for m in re.finditer(r"<!--(.*?)-->", texto, re.S):
        n = texto.count("\n", 0, m.start()) + 1
        hallazgos += 1
        print("%s:%d  comentario HTML oculto: %s" % (ruta, n, " ".join(m.group(1).split())[:100]))
    if not hallazgos:
        print("%s: sin hallazgos" % ruta)
    return hallazgos


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    total = sum(auditar(r) for r in sys.argv[1:])
    print("Total de hallazgos:", total)
