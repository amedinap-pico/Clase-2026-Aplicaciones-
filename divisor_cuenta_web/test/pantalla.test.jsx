import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { afterEach, describe, expect, it } from 'vitest'
import { RedondeoExacto } from '../src/data/redondeoExacto.js'
import { RedondeoHaciaArriba } from '../src/data/redondeoHaciaArriba.js'
import { CalcularDivision } from '../src/domain/calcularDivision.js'
import { ValidarEntrada } from '../src/domain/validarEntrada.js'
import { PantallaDivisor } from '../src/presentation/PantallaDivisor.jsx'

const dependencias = {
  calcularDivision: new CalcularDivision(),
  validarEntrada: new ValidarEntrada(),
  estrategias: {
    exacto: new RedondeoExacto(),
    'hacia-arriba': new RedondeoHaciaArriba(),
  },
}

function renderPantalla() {
  return render(<PantallaDivisor {...dependencias} />)
}

async function completarCuenta({ monto, personas, propina }) {
  const usuario = userEvent.setup()
  await usuario.type(screen.getByRole('textbox', { name: 'Monto total' }), monto)
  await usuario.type(
    screen.getByRole('textbox', { name: 'Número de personas' }),
    personas,
  )
  const campoPropina = screen.getByRole('textbox', { name: 'Propina (%)' })
  await usuario.clear(campoPropina)
  await usuario.type(campoPropina, propina)
  await usuario.click(screen.getByRole('button', { name: 'Calcular' }))
}

afterEach(cleanup)

describe('PantallaDivisor', () => {
  it('presenta los valores iniciales documentados', () => {
    renderPantalla()

    expect(screen.getByRole('textbox', { name: 'Monto total' }).value).toBe('')
    expect(
      screen.getByRole('textbox', { name: 'Número de personas' }).value,
    ).toBe('')
    expect(screen.getByRole('textbox', { name: 'Propina (%)' }).value).toBe(
      '10',
    )
    expect(screen.getByRole('combobox', { name: 'Modo de redondeo' }).value).toBe(
      'exacto',
    )
    expect(
      screen.getByRole('button', { name: 'Calcular', type: 'submit' }),
    ).toBeTruthy()
  })

  it('aceptación 1: calcula 27.50 con propina del 10%', async () => {
    renderPantalla()

    await completarCuenta({ monto: '100', personas: '4', propina: '10' })

    expect(screen.getByRole('heading', { name: 'Pago por persona' })).toBeTruthy()
    expect(screen.getByText('27.50')).toBeTruthy()
  })

  it('aceptación 2: calcula 30.00 sin propina', async () => {
    renderPantalla()

    await completarCuenta({ monto: '90', personas: '3', propina: '0' })

    expect(screen.getByText('30.00')).toBeTruthy()
  })

  it('aceptación 3: informa cero personas y oculta el resultado anterior', async () => {
    renderPantalla()
    await completarCuenta({ monto: '100', personas: '4', propina: '10' })
    expect(screen.getByText('27.50')).toBeTruthy()

    const usuario = userEvent.setup()
    const campoPersonas = screen.getByRole('textbox', {
      name: 'Número de personas',
    })
    await usuario.clear(campoPersonas)
    await usuario.type(campoPersonas, '0')
    await usuario.click(screen.getByRole('button', { name: 'Calcular' }))

    expect(screen.getByRole('alert').textContent).toBe(
      'Debe haber al menos una persona',
    )
    expect(screen.queryByRole('heading', { name: 'Pago por persona' })).toBeNull()
    expect(campoPersonas.getAttribute('aria-invalid')).toBe('true')
  })

  it('aceptación 4: informa un monto no numérico', async () => {
    renderPantalla()

    await completarCuenta({ monto: 'abc', personas: '4', propina: '0' })

    expect(screen.getByRole('alert').textContent).toBe('Monto inválido')
    expect(
      screen.getByRole('textbox', { name: 'Monto total' }).getAttribute(
        'aria-invalid',
      ),
    ).toBe('true')
    expect(screen.queryByRole('heading', { name: 'Pago por persona' })).toBeNull()
  })

  it('aceptaciones 5 y 6: permite alternar entre redondeo exacto y hacia arriba', async () => {
    renderPantalla()
    await completarCuenta({ monto: '10', personas: '3', propina: '0' })
    expect(screen.getByText('3.33')).toBeTruthy()

    fireEvent.change(screen.getByRole('combobox', { name: 'Modo de redondeo' }), {
      target: { value: 'hacia-arriba' },
    })
    await userEvent.setup().click(screen.getByRole('button', { name: 'Calcular' }))

    expect(screen.getByText('4.00')).toBeTruthy()
    expect(screen.queryByText('3.33')).toBeNull()
  })
})
