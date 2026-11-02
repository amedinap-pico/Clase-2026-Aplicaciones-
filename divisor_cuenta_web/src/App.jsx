import './App.css'
import { PantallaDivisor } from './presentation/PantallaDivisor.jsx'

function App({ calcularDivision, validarEntrada, estrategias }) {
  return (
    <PantallaDivisor
      calcularDivision={calcularDivision}
      validarEntrada={validarEntrada}
      estrategias={estrategias}
    />
  )
}

export default App
