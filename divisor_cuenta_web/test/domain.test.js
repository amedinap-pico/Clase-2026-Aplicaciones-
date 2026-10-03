import assert from 'node:assert/strict'
import test from 'node:test'
import { RedondeoExacto } from '../src/data/redondeoExacto.js'
import { RedondeoHaciaArriba } from '../src/data/redondeoHaciaArriba.js'
import { CalcularDivision } from '../src/domain/calcularDivision.js'
import { Cuenta } from '../src/domain/cuenta.js'
import { ValidarEntrada } from '../src/domain/validarEntrada.js'

const validador = new ValidarEntrada()
const calculador = new CalcularDivision()
const exacto = new RedondeoExacto()
const haciaArriba = new RedondeoHaciaArriba()

const casosAceptacion = [
  {
    nombre: '100 entre 4 con propina del 10% da 27.50',
    cuenta: new Cuenta({ monto: 100, personas: 4, propina: 10 }),
    estrategia: exacto,
    esperado: 27.5,
  },
  {
    nombre: '90 entre 3 sin propina da 30.00',
    cuenta: new Cuenta({ monto: 90, personas: 3, propina: 0 }),
    estrategia: exacto,
    esperado: 30,
  },
  {
    nombre: '10 entre 3 en modo exacto da 3.33',
    cuenta: new Cuenta({ monto: 10, personas: 3, propina: 0 }),
    estrategia: exacto,
    esperado: 3.33,
  },
  {
    nombre: '10 entre 3 hacia arriba da 4.00',
    cuenta: new Cuenta({ monto: 10, personas: 3, propina: 0 }),
    estrategia: haciaArriba,
    esperado: 4,
  },
]

for (const caso of casosAceptacion) {
  test(caso.nombre, () => {
    assert.equal(validador.validar(caso.cuenta), null)
    const resultado = calculador.calcular(caso.cuenta, caso.estrategia)
    assert.equal(resultado.pagoPorPersona, caso.esperado)
    assert.equal(resultado.pagoPorPersona.toFixed(2), caso.esperado.toFixed(2))
  })
}

test('rechaza cero personas y no intenta dividir', () => {
  const cuenta = new Cuenta({ monto: 50, personas: 0, propina: 0 })
  assert.equal(validador.validar(cuenta), 'Debe haber al menos una persona')
})

test('rechaza un monto no numérico', () => {
  const cuenta = new Cuenta({ monto: Number.NaN, personas: 4, propina: 0 })
  assert.equal(validador.validar(cuenta), 'Monto inválido')
})

test('valida monto, personas y propina antes del cálculo', () => {
  assert.equal(
    validador.validar(new Cuenta({ monto: -1, personas: 1, propina: 0 })),
    'Monto inválido',
  )
  assert.equal(
    validador.validar(new Cuenta({ monto: 1, personas: 1.5, propina: 0 })),
    'Debe haber al menos una persona',
  )
  assert.equal(
    validador.validar(new Cuenta({ monto: 1, personas: 1, propina: Infinity })),
    'Propina inválida',
  )
})

test('el cálculo acepta estrategias intercambiables', () => {
  const cuenta = new Cuenta({ monto: 10, personas: 3, propina: 0 })
  const estrategiaDePrueba = {
    redondear: (monto) => ({ pagoPorPersona: monto * 2 }),
  }
  assert.equal(
    calculador.calcular(cuenta, estrategiaDePrueba).pagoPorPersona,
    20 / 3,
  )
})
