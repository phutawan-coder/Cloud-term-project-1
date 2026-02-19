import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import Header from './Header.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <div className="bg-blue-100 mx-10 my-10 rounded max-h-full flex flex-row-reverse">
    <Header  />
    </div>
  </StrictMode>,
)
