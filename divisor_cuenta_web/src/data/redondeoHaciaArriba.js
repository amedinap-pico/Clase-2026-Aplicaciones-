import { EstrategiaRedondeo } from '../domain/estrategiaRedondeo.js'
import { Resultado } from '../domain/resultado.js'

export class RedondeoHaciaArriba extends EstrategiaRedondeo {
  redondear(monto) {
    return new Resultado({ pagoPorPersona: Math.ceil(monto) })
  }
}
