---
name: incident-investigator
description: >-
  Investiga archivos CSV sintéticos o autorizados de autenticación y seguridad
  cuando se solicite identificar intentos sospechosos, cambios de rol no
  aprobados o posibles secretos expuestos. Se activa para análisis de incidentes
  basados en eventos y evidencia; no se activa por defecto para conteos,
  resúmenes o visualizaciones descriptivas sin clasificación de amenazas.
---

# Incident Investigator

## Alcance y seguridad

- Analiza únicamente los archivos proporcionados y autorizados por el usuario.
- No accedas a redes, no consultes IP y no trates IP de documentación como
  infraestructura real.
- No inventes eventos, filas, contexto, identidades ni atribuciones de
  culpabilidad.
- Si un campo `detail` contiene `token=`, nunca reveles su valor: escribe
  `[REDACTED]`.
- Las reglas producen alertas justificadas para revisión, no conclusiones
  forenses ni prueba de intrusión.

## Procedimiento

1. Confirma cuál es el archivo solicitado y que la petición sea una
   investigación de seguridad, no solo una consulta descriptiva.
2. Inspecciona el encabezado y el formato del CSV. Verifica las columnas
   necesarias (`timestamp`, `ip`, `user`, `event`, `result`, `detail`) y cómo
   obtener números de fila del archivo original. La fila 1 es el encabezado.
   Si faltan campos o hay valores que impiden aplicar una regla, indícalo.
3. Abre `references/detection-rules.md` antes de evaluar eventos agrupados,
   umbrales, cambios de rol, secretos o falsos positivos. Aplícala sin cambiar
   los criterios para acomodarlos a los datos.
4. Ordena los eventos por `timestamp` para evaluar ventanas, pero conserva y
   cita siempre los números de fila originales. Compara eventos y resultados
   con coincidencia exacta y cuenta únicamente los tipos indicados en las
   reglas.
5. Separa cada regla que se cumple de la evidencia que solo aporta contexto.
   Distingue una alerta basada en el registro de un hecho confirmado. Si no
   puedes identificar duplicados inequívocamente, registra esa limitación.
6. Reporta cada alerta con la tabla estandarizada indicada abajo. Incluye las
   filas y valores necesarios para reproducir el hallazgo. En posibles tokens,
   redacta el valor tanto en la tabla como en cualquier cita.
7. Declara explícitamente incertidumbres, campos ausentes, ambigüedades,
   limitaciones de los datos y reglas que no se pudieron evaluar. No afirmes que
   un patrón no ocurrió si los datos no permiten comprobarlo.

## Formato de salida

| alerta | severidad orientativa | regla | timestamp | ip | usuario | filas/evidencia | limitaciones |
|---|---|---|---|---|---|---|---|

Usa una fila por alerta. Si no hay alertas justificadas, indícalo y resume qué
reglas se evaluaron. La severidad es orientativa; no equivale a impacto
confirmado.
