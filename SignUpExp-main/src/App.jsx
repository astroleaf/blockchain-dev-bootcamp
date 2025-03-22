import { createBrowserRouter,RouterProvider } from 'react-router-dom'
import Login from './pages/Login'
import Home from './pages/Home'
import SignUp from './pages/SignUp'
import './App.css'

function App() {

  const router = createBrowserRouter([
    {path:"/",element:<Login/>},
    {path:"/home",element:<Home/>},
    {path:"/signup",element:<SignUp/>}
  ])
  return (
    <>
     <RouterProvider router={router}></RouterProvider>
    </>
  )
}

export default App
