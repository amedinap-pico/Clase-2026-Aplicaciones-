# Deber 5 — MCP Detective

## 1. Arquitectura

El LLM interpreta la solicitud y propone qué herramienta llamar. El host o harness mantiene la conversación, presenta las herramientas disponibles y coordina al cliente MCP. El cliente MCP envía las llamadas al servidor por stdio y devuelve sus respuestas al host. El servidor MCP ejecuta el código Python: carga los casos, devuelve eventos y valida y registra alertas. El proceso de Python que ejecuta `server.py` es quien realmente ejecuta la lógica y las validaciones.

## 2. Evidencia

`INC-003` merece investigación porque registra cuatro intentos fallidos de `admin` desde `192.0.2.50` entre las 03:00 y las 03:03, seguidos de un acceso exitoso desde esa misma IP a las 03:04. El patrón es inusual, pero los eventos no demuestran quién inició sesión ni si el acceso fue autorizado; por tanto, no permiten afirmar que hubo una intrusión.

## 3. Validación y seguridad

El servidor rechaza `INC-999`, niveles no permitidos, motivos vacíos y alertas duplicadas mediante errores explícitos. No basta con confiar en el LLM para generar argumentos válidos: puede equivocarse o proponer entradas fuera del contrato. La validación en el servidor protege el estado y garantiza el mismo comportamiento para cualquier cliente.

## Agente, conexión e instrucciones

- **Agente usado:** asistente basado en Copilot SDK en VS Code para construir y revisar el servidor.
- **Comprobación realizada:** `python -m pytest -vv` ejecutó siete pruebas y todas pasaron. En el Inspector descubrí las tres herramientas; confirmé la lista de casos, los seis eventos de `INC-002`, el error para `INC-999`, el registro válido, el duplicado y los rechazos del nivel y motivo inválidos. Desconecté y reconecté el servidor y pude registrar de nuevo la alerta, confirmando que el estado se reinicia. En una conversación nueva el host inició una llamada a `listar_casos`, pero no devolvió su resultado; no pude verificar las consultas y el registro desde Copilot. La captura obligatoria `agente_tools.png` sigue pendiente y no se reemplaza por evidencia del Inspector.
- **Instalación:** con Python 3.11 o superior, ejecutar `python -m pip install "mcp[cli]>=2,<3" pytest`.
- **Pruebas:** desde la raíz del repositorio, ejecutar `python -m pytest mcp-detective -vv`.
- **Inspector:** desde la raíz, ejecutar `mcp dev mcp-detective/server.py`. En el Inspector, descubrir las tres tools y probar D1–D7; repetir el registro antes y después de reiniciar el proceso para verificar el estado en memoria.
- **Conexión del host:** `.vscode/mcp.json` en la raíz y `mcp-detective/.vscode/mcp.json` configuran el servidor por stdio para el workspace raíz o para abrir directamente la carpeta del servidor. Inicia o reinicia el servidor MCP en VS Code, abre una conversación nueva y comprueba que las llamadas terminan con resultados; guarda la traza real como `evidencias/agente_tools.png`.

## Evidencias

`evidencias/` contiene capturas reales del código, del Inspector conectado, de la lista de casos y de los seis eventos de `INC-002`, además de los rechazos y la salida detallada de pytest. La única captura que falta es `agente_tools.png`: debe mostrar las llamadas MCP reales del host de Copilot en una conversación nueva; no se sustituye por una captura del Inspector.
