import { afterEach, describe, expect, it, vi } from 'vitest'
import { RedondeoExacto } from '../src/data/redondeoExacto.js'
import { RedondeoHaciaArriba } from '../src/data/redondeoHaciaArriba.js'
import { CalcularDivision } from '../src/domain/calcularDivision.js'
import { Cuenta } from '../src/domain/cuenta.js'
import { ValidarEntrada } from '../src/domain/validarEntrada.js'
import { casos } from './casosDePrueba.js'

const validarEntrada = new ValidarEntrada()
const calcularDivision = new CalcularDivision()
const redondeoExacto = new RedondeoExacto()
const redondeoHaciaArriba = new RedondeoHaciaArriba()
const estrategias = {
  exacto: redondeoExacto,
  arriba: redondeoHaciaArriba,
}

afterEach(() => vi.restoreAllMocks())

describe('Dominio: aceptación y reglas de división', () => {
  it.each(casos)('$nombre', (caso) => {
    const calcular = vi.spyOn(calcularDivision, 'calcular')
    const cuenta = new Cuenta({
      monto: caso.monto,
      personas: caso.personas,
      propina: caso.propina,
    })
    const error = validarEntrada.validar(cuenta)

    if (caso.errorEsperado) {
      expect(error).toBe(caso.errorEsperado)
      expect(calcular).not.toHaveBeenCalled()
      return
    }

    expect(error).toBeNull()
    const estrategia = estrategias[caso.modo]
    const resultado = calcularDivision.calcular(cuenta, estrategia)
    expect(calcular).toHaveBeenCalledOnce()
    expect(resultado.pagoPorPersona).toBeCloseTo(caso.esperado, 2)
  })

  it('LSP: el caso de uso acepta estrategias intercambiables', () => {
    const cuenta = new Cuenta({ monto: 10, personas: 3, propina: 0 })

    expect(
      calcularDivision.calcular(cuenta, redondeoExacto).pagoPorPersona,
    ).toBeCloseTo(3.33, 2)
    expect(
      calcularDivision.calcular(cuenta, redondeoHaciaArriba).pagoPorPersona,
    ).toBeCloseTo(4, 2)
  })

  it('rechaza montos y propinas negativos o no finitos', () => {
    expect(
      validarEntrada.validar(
        new Cuenta({ monto: -1, personas: 1, propina: 0 }),
      ),
    ).toBe('Monto inválido')
    expect(
      validarEntrada.validar(
        new Cuenta({ monto: 1, personas: 1, propina: Number.POSITIVE_INFINITY }),
      ),
    ).toBe('Propina inválida')
  })

  it('rechaza cantidades de personas no enteras', () => {
    expect(
      validarEntrada.validar(
        new Cuenta({ monto: 1, personas: 1.5, propina: 0 }),
      ),
    ).toBe('Debe haber al menos una persona')
  })
})
