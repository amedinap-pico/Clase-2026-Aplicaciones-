import json
from pathlib import Path
from typing import TypedDict

from mcp.server import MCPServer


class Evento(TypedDict):
    hora: str
    usuario: str
    ip: str
    evento: str


class Caso(TypedDict):
    sistema: str
    eventos: list[Evento]


class Alerta(TypedDict):
    caso_id: str
    nivel: str
    motivo: str
    estado: str


def _cargar_casos() -> dict[str, Caso]:
    """Carga los casos desde el archivo junto a este módulo."""
    ruta_casos = Path(__file__).resolve().with_name("casos.json")
    with ruta_casos.open(encoding="utf-8") as archivo:
        return json.load(archivo)


CASOS = _cargar_casos()
ALERTAS: dict[str, Alerta] = {}


def _listar_casos(casos: dict[str, Caso]) -> list[dict]:
    """Resume los identificadores, sistemas y cantidad de eventos."""
    return [
        {
            "id": caso_id,
            "sistema": caso["sistema"],
            "cantidad_eventos": len(caso["eventos"]),
        }
        for caso_id, caso in casos.items()
    ]


def _consultar_eventos(casos: dict[str, Caso], caso_id: str) -> list[dict]:
    """Devuelve los eventos de un caso existente o informa si no existe."""
    if not isinstance(caso_id, str) or caso_id not in casos:
        raise ValueError(f"No existe el caso '{caso_id}'.")
    return list(casos[caso_id]["eventos"])


def _registrar_alerta(
    casos: dict[str, Caso],
    alertas: dict[str, Alerta],
    caso_id: str,
    nivel: str,
    motivo: str,
) -> dict:
    """Valida y guarda una única alerta por caso en memoria."""
    if not isinstance(caso_id, str) or caso_id not in casos:
        raise ValueError(f"No existe el caso '{caso_id}'.")
    if not isinstance(nivel, str) or nivel not in ("bajo", "medio", "alto"):
        raise ValueError("El nivel debe ser exactamente 'bajo', 'medio' o 'alto'.")
    if not isinstance(motivo, str) or not motivo.strip():
        raise ValueError("El motivo debe contener al menos un carácter no blanco.")
    if caso_id in alertas:
        raise ValueError(f"Ya existe una alerta registrada para el caso '{caso_id}'.")

    alerta: Alerta = {
        "caso_id": caso_id,
        "nivel": nivel,
        "motivo": motivo,
        "estado": "registrada",
    }
    alertas[caso_id] = alerta
    return alerta.copy()


mcp = MCPServer("MCP Detective")


@mcp.tool()
def listar_casos() -> list[dict]:
    """Lista los casos con su sistema y cantidad de eventos, sin conclusiones."""
    return _listar_casos(CASOS)


@mcp.tool()
def consultar_eventos(caso_id: str) -> list[dict]:
    """Devuelve los eventos exactos del caso indicado."""
    return _consultar_eventos(CASOS, caso_id)


@mcp.tool()
def registrar_alerta(caso_id: str, nivel: str, motivo: str) -> dict:
    """Registra en memoria una alerta válida y única para un caso."""
    return _registrar_alerta(CASOS, ALERTAS, caso_id, nivel, motivo)


if __name__ == "__main__":
    mcp.run(transport="stdio")
