import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RedondeoExacto } from './data/redondeoExacto.js'
import { RedondeoHaciaArriba } from './data/redondeoHaciaArriba.js'
import { CalcularDivision } from './domain/calcularDivision.js'
import { ValidarEntrada } from './domain/validarEntrada.js'
import './index.css'
import App from './App.jsx'

const calcularDivision = new CalcularDivision()
const validarEntrada = new ValidarEntrada()
const estrategias = {
  exacto: new RedondeoExacto(),
  'hacia-arriba': new RedondeoHaciaArriba(),
}

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App
      calcularDivision={calcularDivision}
      validarEntrada={validarEntrada}
      estrategias={estrategias}
    />
  </StrictMode>,
)
