import { useDivisor } from './useDivisor.js'
import { CampoEntrada } from './CampoEntrada.jsx'

export function PantallaDivisor({
  calcularDivision,
  validarEntrada,
  estrategias,
}) {
  const { campos, error, resultado, actualizarCampo, calcular } = useDivisor({
    calcularDivision,
    validarEntrada,
    estrategias,
  })

  return (
    <main className="app-shell">
      <section className="calculator-card" aria-labelledby="app-title">
        <p className="eyebrow">Deber 2 · Aplicación web</p>
        <h1 id="app-title">Dividir cuenta</h1>
        <p className="welcome-copy">
          Ingresa los datos de la cuenta para calcular cuánto paga cada persona.
        </p>

        <form className="calculator-form" onSubmit={calcular} noValidate>
          <CampoEntrada
            id="monto"
            label="Monto total"
            name="monto"
            value={campos.monto}
            onChange={actualizarCampo}
            inputMode="decimal"
            placeholder="Ej. 100.00"
            error={error === 'Monto inválido' ? error : null}
          />

          <CampoEntrada
            id="personas"
            label="Número de personas"
            name="personas"
            value={campos.personas}
            onChange={actualizarCampo}
            inputMode="numeric"
            placeholder="Ej. 4"
            error={
              error === 'Debe haber al menos una persona' ? error : null
            }
          />

          <CampoEntrada
            id="propina"
            label="Propina (%)"
            name="propina"
            value={campos.propina}
            onChange={actualizarCampo}
            inputMode="decimal"
            placeholder="Ej. 10"
            error={error === 'Propina inválida' ? error : null}
          />

          <div className="form-field">
            <label htmlFor="redondeo">Modo de redondeo</label>
            <select
              id="redondeo"
              name="redondeo"
              value={campos.redondeo}
              onChange={actualizarCampo}
            >
              <option value="exacto">Exacto</option>
              <option value="hacia-arriba">Hacia arriba</option>
            </select>
          </div>

          <button className="calculate-button" type="submit">
            Calcular
          </button>
        </form>

        {error && (
          <p className="form-error" role="alert">
            {error}
          </p>
        )}

        {resultado && (
          <section
            className="result-card"
            aria-live="polite"
            aria-labelledby="result-title"
          >
            <h2 id="result-title">Pago por persona</h2>
            <p className="result-amount">
              {resultado.pagoPorPersona.toFixed(2)}
            </p>
          </section>
        )}
      </section>
    </main>
  )
}
