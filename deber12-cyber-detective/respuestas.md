# Respuestas — Misión 6

## 1. Agent Skill frente a Plugin

`incident-investigator` es un Agent Skill: una carpeta con instrucciones y
recursos que guían cuándo y cómo investigar logs. Un Plugin puede distribuirlo
junto con otros componentes soportados por la plataforma, por ejemplo comandos,
hooks, servidores MCP y un manifiesto. El skill por sí solo no contiene ni
implica esos componentes.

## 2. Ralph Loop

Un Ralph Loop podría analizar el mismo CSV y comprobar criterios verificables:
columnas requeridas, coincidencia exacta de `event`/`result`, filas citadas
existentes, umbrales aplicados y tokens redactados. Si una comprobación falla,
la siguiente iteración corregiría solo ese error y volvería a comprobar el
archivo original. El límite sería de 3 iteraciones. Pararía antes cuando todas
las comprobaciones pasen; si alguna sigue fallando en la tercera, informaría el
fallo y la evidencia faltante. No modificaría el CSV ni inventaría eventos,
filas o evidencia nueva.
