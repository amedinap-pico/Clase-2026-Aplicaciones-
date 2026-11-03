import pytest

import server


@pytest.fixture(autouse=True)
def alertas_vacias(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(server, "ALERTAS", {})


def test_listar_casos_devuelve_los_tres_casos() -> None:
    casos = server.listar_casos()

    assert len(casos) == 3
    assert {caso["id"] for caso in casos} == {"INC-001", "INC-002", "INC-003"}


def test_consultar_eventos_devuelve_eventos_exactos() -> None:
    assert server.consultar_eventos("INC-001") == server.CASOS["INC-001"]["eventos"]


def test_consultar_eventos_inexistentes_lanza_value_error() -> None:
    with pytest.raises(ValueError, match="No existe el caso 'INC-999'"):
        server.consultar_eventos("INC-999")


def test_registrar_alerta_valida() -> None:
    alerta = server.registrar_alerta("INC-001", "medio", "Revisar el inicio de sesión.")

    assert alerta == {
        "caso_id": "INC-001",
        "nivel": "medio",
        "motivo": "Revisar el inicio de sesión.",
        "estado": "registrada",
    }


def test_registrar_alerta_rechaza_duplicados_en_la_misma_instancia() -> None:
    server.registrar_alerta("INC-001", "medio", "Primera alerta.")

    with pytest.raises(ValueError, match="Ya existe una alerta registrada"):
        server.registrar_alerta("INC-001", "alto", "Alerta duplicada.")


@pytest.mark.parametrize(
    ("nivel", "motivo"),
    [
        ("critico", "Motivo válido"),
        ("alto", "   "),
    ],
)
def test_registrar_alerta_rechaza_nivel_o_motivo_invalidos(
    nivel: str,
    motivo: str,
) -> None:
    with pytest.raises(ValueError):
        server.registrar_alerta("INC-001", nivel, motivo)
