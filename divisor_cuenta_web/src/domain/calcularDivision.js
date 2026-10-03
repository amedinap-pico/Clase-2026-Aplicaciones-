import { Resultado } from './resultado.js'

export class CalcularDivision {
  calcular(cuenta, estrategia) {
    if (typeof estrategia?.aplicar !== 'function') {
      throw new TypeError('Se requiere una estrategia de redondeo válida.')
    }

    const total = cuenta.monto * (1 + cuenta.propina / 100)
    const pagoSinRedondear = total / cuenta.personas
    if (!Number.isFinite(pagoSinRedondear)) {
      throw new RangeError('El resultado del cálculo no se puede representar.')
    }

    const resultado = estrategia.aplicar(pagoSinRedondear)
    if (!Number.isFinite(resultado?.pagoPorPersona)) {
      throw new RangeError('El resultado del cálculo no se puede representar.')
    }

    return new Resultado({ pagoPorPersona: resultado.pagoPorPersona })
  }
}
