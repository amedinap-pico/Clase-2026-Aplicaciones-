import { cleanup, render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { afterEach, describe, expect, it, vi } from 'vitest'
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

afterEach(cleanup)
afterEach(() => vi.restoreAllMocks())

describe('PantallaDivisor', () => {
  it('calcula 27.50 para una cuenta de 100 entre 4 con 10% de propina', async () => {
    const usuario = userEvent.setup()
    render(<PantallaDivisor {...dependencias} />)

    await usuario.type(screen.getByLabelText('Monto total'), '100')
    await usuario.type(screen.getByLabelText('Número de personas'), '4')
    await usuario.clear(screen.getByLabelText('Propina (%)'))
    await usuario.type(screen.getByLabelText('Propina (%)'), '10')
    await usuario.click(screen.getByRole('button', { name: 'Calcular' }))

    expect(screen.getByText('27.50')).toBeInTheDocument()
  })

  it('muestra error para cero personas y no presenta resultado numérico', async () => {
    const usuario = userEvent.setup()
    const calcular = vi.spyOn(dependencias.calcularDivision, 'calcular')
    render(<PantallaDivisor {...dependencias} />)

    await usuario.type(screen.getByLabelText('Monto total'), '50')
    await usuario.type(screen.getByLabelText('Número de personas'), '0')
    await usuario.clear(screen.getByLabelText('Propina (%)'))
    await usuario.type(screen.getByLabelText('Propina (%)'), '0')
    await usuario.click(screen.getByRole('button', { name: 'Calcular' }))

    expect(screen.getByRole('alert')).toHaveTextContent(
      'Debe haber al menos una persona',
    )
    expect(screen.queryByRole('heading', { name: 'Pago por persona' })).toBeNull()
    expect(calcular).not.toHaveBeenCalled()
  })

  it('muestra error cuando el monto ingresado no es numérico', async () => {
    const usuario = userEvent.setup()
    render(<PantallaDivisor {...dependencias} />)

    await usuario.type(screen.getByLabelText('Monto total'), 'abc')
    await usuario.type(screen.getByLabelText('Número de personas'), '4')
    await usuario.clear(screen.getByLabelText('Propina (%)'))
    await usuario.type(screen.getByLabelText('Propina (%)'), '0')
    await usuario.click(screen.getByRole('button', { name: 'Calcular' }))

    expect(screen.getByRole('alert')).toHaveTextContent('Monto inválido')
    expect(screen.queryByRole('heading', { name: 'Pago por persona' })).toBeNull()
  })
})
