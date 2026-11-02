import { useState } from 'react'
import { Cuenta } from '../domain/cuenta.js'

const estadoInicial = {
  monto: '',
  personas: '',
  propina: '10',
  redondeo: 'exacto',
}

function convertirNumero(valor) {
  const limpio = valor.trim()
  const formatoDecimal =
    /^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?$/i
  return limpio !== '' && formatoDecimal.test(limpio)
    ? Number(limpio)
    : Number.NaN
}

export function useDivisor({
  calcularDivision,
  validarEntrada,
  estrategias,
}) {
  const [campos, setCampos] = useState(estadoInicial)
  const [error, setError] = useState(null)
  const [resultado, setResultado] = useState(null)

  function actualizarCampo(event) {
    const { name, value } = event.target
    setCampos((actuales) => ({ ...actuales, [name]: value }))
  }

  function calcular(event) {
    event.preventDefault()

    const cuenta = new Cuenta({
      monto: convertirNumero(campos.monto),
      personas: convertirNumero(campos.personas),
      propina: convertirNumero(campos.propina),
    })
    const errorValidacion = validarEntrada.validar(cuenta)

    if (errorValidacion) {
      setError(errorValidacion)
      setResultado(null)
      return
    }

    try {
      const estrategia = estrategias[campos.redondeo]
      const nuevoResultado = calcularDivision.calcular(cuenta, estrategia)
      setResultado(nuevoResultado)
      setError(null)
    } catch (calculoError) {
      if (!(calculoError instanceof RangeError)) {
        throw calculoError
      }
      setError(calculoError.message)
      setResultado(null)
    }
  }

  return {
    campos,
    error,
    resultado,
    actualizarCampo,
    calcular,
  }
}
