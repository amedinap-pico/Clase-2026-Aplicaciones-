export class ValidarEntrada {
  validar(cuenta) {
    if (!Number.isFinite(cuenta?.monto) || cuenta.monto < 0) {
      return 'Monto inválido'
    }
    if (!Number.isInteger(cuenta?.personas) || cuenta.personas < 1) {
      return 'Debe haber al menos una persona'
    }
    if (!Number.isFinite(cuenta?.propina) || cuenta.propina < 0) {
      return 'Propina inválida'
    }
    return null
  }
}
