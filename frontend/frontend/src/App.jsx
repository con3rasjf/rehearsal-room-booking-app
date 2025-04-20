import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import ReservacionEnsayos from './views/ReservacionEnsayos'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="App">
      <ReservacionEnsayos />
    </div>
  )
}

export default App
