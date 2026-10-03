import { EstrategiaRedondeo } from '../domain/estrategiaRedondeo.js'
import { Resultado } from '../domain/resultado.js'

export class RedondeoExacto extends EstrategiaRedondeo {
  redondear(monto) {
    const centavos = monto * 100
    if (!Number.isFinite(centavos)) {
      throw new RangeError('El resultado del cálculo no se puede representar.')
    }

    const pagoPorPersona =
      Math.round(centavos + Number.EPSILON * Math.abs(centavos)) / 100
    return new Resultado({ pagoPorPersona })
  }
}
