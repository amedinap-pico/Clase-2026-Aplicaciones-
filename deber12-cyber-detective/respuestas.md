# Respuestas — Misión 6

## 1. Agent Skill frente a Plugin

`incident-investigator` es un Agent Skill porque aporta instrucciones y una
referencia de dominio que guían al agente cuándo y cómo investigar logs. Un
Plugin puede empaquetar el skill junto con componentes adicionales dependientes
de la plataforma, como comandos, hooks, integraciones MCP y un manifiesto de
distribución. El skill por sí solo no implica que esos componentes existan.

## 2. Ralph Loop

Un Ralph Loop podría repetir el análisis y corregir solo errores detectados por
comprobaciones verificables —por ejemplo, columnas esperadas, filas citadas y
redacción de tokens—. Limitaría el ciclo a un máximo de 3 iteraciones y lo
detendría antes cuando todas las comprobaciones pasen. Si después de la tercera
iteración siguen fallando, reportaría el fallo y la evidencia faltante, sin
fabricar eventos ni convertir una alerta en un hecho confirmado.
